//
//  Packable.swift
//  Monaka
//
//  Created by naru on 2016/08/17.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation

// MARK: Packable

/// Protocol for mutual conversion of struct and NSData
public protocol Packable {
    
    /// Identifier. (Implemented default behavior.)
//    static var packedIdentifier: String { get }
    
    /// Identifier. (Implemented default behavior.)
//    var packedIdentifier: String { get }
    
    /// Number of bytes of identifier. (Implemented default behavior.)
//    var packedIDLength: Int { get }
    
    /// Number of bytes of the whole packed data.
    var packedDataLength: Int { get }
    
    /// Metadata for the packed data.
    var packedHeaderData: [NSData] { get }
    
    /// Body data for the packed data.
    var packedBodyData: [NSData] { get }
    
    /// The whole of packed data. (Implemented default behavior.)
//    var packedData: NSData { get }
    
    /// Closure to un-pack data.
    static var unpackProcedure: (data: NSData) -> Packable? { get }
}

/// Define default implementation for the Packable.
public extension Packable {
    
    /// Return name of type.
    public static var packedIdentifier: String {
        switch self {
        case is ArrayType:
            return "Array"
        case is DictionaryType:
            return "Dictionary"
        default:
            return "\(self)"
        }
    }
    
    /// Return name of type.
    public var packedIdentifier: String {
        switch self {
        case is ArrayType:
            return "Array"
        case is DictionaryType:
            return "Dictionary"
        default:
            return "\(Mirror(reflecting: self).subjectType)"
        }
    }
    
    /// Length of identifier data
    public var packedIDLength: Int {
        return sizeof(UInt8) + self.packedIdentifier.characters.count
    }
    
    /// Identifier data
    public var packedIdentifierData: NSData {
        // count
        let identifier: String = self.packedIdentifier
        var count: UInt8 = UInt8(identifier.characters.count)
        // + identifier string
        let identifierData: NSMutableData = NSMutableData(bytes: &count, length: sizeof(UInt8))
        if let data = identifier.dataUsingEncoding(NSUTF8StringEncoding) {
            identifierData.appendData(data)
        }
        return identifierData
    }
    
    /// Whole of packed data
    public var packedData: NSData {
        let data: NSMutableData = NSMutableData(data: self.packedIdentifierData)
        for subdata in self.packedHeaderData + self.packedBodyData {
            data.appendData(subdata)
        }
        return NSData(data: data)
    }
    
    /// Store procedure to unarchive data on memory.
    public static func activatePack() {
        Monaka.registerUnpackProcedure(identifier: self.packedIdentifier, procedure: self.unpackProcedure)
    }
}


