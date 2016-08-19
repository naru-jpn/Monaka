//
//  Monaka.swift
//  Monaka
//
//  Created by naru on 2016/08/17.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation

/// **Monaka** is Delicious Library.
public class Monaka {
    
    /// Shared Instance.
    private static let sharedInstance = Monaka()
    
    /// Store procedure to unpack data.
    private var unpackProcedures: [String: ((data: NSData) -> Packable?)] = [:]
    
    /// Store procedure to restore data.
    private var restoreProcedures: [String: ((dictionary: [String: Packable]) -> Packable?)] = [:]

    /// Register procedure to unpack data.
    /// - parameter identifier: string to specify struct
    /// - parameter procedure: procedure to store
    public class func registerUnpackProcedure(identifier identifier: String, procedure: ((data: NSData) -> Packable?)) {
        self.sharedInstance.unpackProcedures[identifier] = procedure
    }
    
    /// Register procedure to restore data.
    /// - parameter identifier: string to specify struct
    /// - parameter procedure: procedure to store
    public class func registerRestoreProcedure(identifier identifier: String, procedure: ((dictionary: [String: Packable]) -> Packable?)) {
        self.sharedInstance.restoreProcedures[identifier] = procedure
    }
    
    /// Return stored procedure to unpack.
    /// - parameter identifier: string to specify struct
    /// - returns: stored procedure or nil if procedure for identifier is not stored
    private func unpackProcedure(identifier identifier: String) -> ((data: NSData) -> Packable?)? {
        guard let procedure: ((data: NSData) -> Packable?) = self.unpackProcedures[identifier] else {
            return nil
        }
        return procedure
    }
    
    /// Return stored procedure to retore struct.
    /// - parameter identifier: string to specify struct
    /// - returns: stored procedure or nil if procedure for identifier is not stored
    private func restoreProcedure(identifier identifier: String) -> ((dictionary: [String: Packable]) -> Packable?)? {
        guard let procedure: ((dictionary: [String: Packable]) -> Packable?) = self.restoreProcedures[identifier] else {
            return nil
        }
        return procedure
    }
    
    /// Unpack data.
    /// - parameter data: data to unpack
    /// - returns: unpacked object
    private func unpack(data data: NSData) -> Packable? {
        
        // length_of_identifier / others
        let splitData1: NSData.SplitData = data.split(length: sizeof(UInt8))
        var count: UInt8 = 0
        splitData1.former.getBytes(&count, length: sizeof(UInt8))
        
        // identifier / others
        let splitData2: NSData.SplitData = splitData1.latter.split(length: Int(count))
        let identifier = NSString(data: splitData2.former, encoding: NSUTF8StringEncoding) as? String ?? ""
                
        guard let procedure = self.unpackProcedure(identifier: identifier) else {
            return nil
        }
        
        let unpacked: Packable? = procedure(data: splitData2.latter)
        
        if let dictionary = unpacked as? [String: Packable], let restoreProcedure = self.restoreProcedure(identifier: identifier) {
            return restoreProcedure(dictionary: dictionary)
        } else {
            return unpacked
        }
    }
    
    /// Pack data.
    /// - parameter data: data to pack
    /// - returns: packed data
    public class func pack(packable: Packable) -> NSData {
        return packable.packedData
    }
    
    /// Unpack data.
    /// - parameter data: data to unpack
    /// - returns: unpacked object
    public class func unpack(data data: NSData) -> Packable? {
        return self.sharedInstance.unpack(data: data)
    }

    /// Register procedures for unpacking and restoring struct.
    /// - parameter withCustomStructActivations: closure to register procedures for custom struct
    public class func activateStandardPackables(withCustomStructActivations withCustomStructActivations:(() -> Void)?) {
        
        Int.activatePack()
        UInt.activatePack()
        Float.activatePack()
        Double.activatePack()
        String.activatePack()
        [Packable].activatePack()
        [String: Packable].activatePack()
        
        if let customStructActivations = withCustomStructActivations {
            customStructActivations()
        }
    }
}
