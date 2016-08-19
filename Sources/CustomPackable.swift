//
//  CustomPackable.swift
//  Monaka
//
//  Created by naru on 2016/08/18.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation

/// Protocol for custom packable struct
public protocol CustomPackable: Packable {
    
    /// Closure to restore struct from unpackable dictionary.
    static var restoreProcedure: ([String: Packable] -> Packable?) { get }
}

public extension CustomPackable {
    
    func packable() -> [String: Packable] {
        
        var children: [String: Packable] = [:]
        Mirror(reflecting: self).children.forEach { label, value in
            if let label = label, value = value as? Packable {
                children[label] = value
            }
        }
        return children
    }
    
    public final var packedIdentifier: String {
        return "\(Mirror(reflecting: self).subjectType)"
    }
    
    public static var packedIdentifier: String {
        return "\(self)"
    }
    
    public var packedDataLength: Int {
        
        let packable: [String: Packable] = self.packable()
        
        let elementsLength: Int = packable.keys.reduce(0) { (length, key) in
            length + key.packedDataLength
        } + packable.values.reduce(0) { (length, value) in
            length + value.packedDataLength
        }
        
        return self.packedIDLength + Int.PackedDataLength*(1+packable.keys.count*2) + elementsLength
    }
    
    public var packedHeaderData: [NSData] {
        let packable: [String: Packable] = self.packable()
        return packable.packedHeaderData
    }
    
    public var packedBodyData: [NSData] {
        let packable: [String: Packable] = self.packable()
        return packable.packedBodyData
    }
    
    public static var unpackProcedure: ((data: NSData) -> Packable?) {
        return [String: Packable].unpackProcedure
    }
    
    /// Store procedure to unpack and restore data on memory.
    public static func activatePack() {
        Monaka.registerUnpackProcedure(identifier: self.packedIdentifier, procedure: self.unpackProcedure)
        Monaka.registerRestoreProcedure(identifier: self.packedIdentifier, procedure: self.restoreProcedure)
    }
}
