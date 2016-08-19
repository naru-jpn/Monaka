//
//  PackableTypes.swift
//  Monaka
//
//  Created by naru on 2016/08/17.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation

// MARK: Standard Packable Types

extension Int: Packable {
    
    public static let PackedDataLength: Int = sizeof(UInt8) + "Int".characters.count + sizeof(Int)
    
    public var packedDataLength: Int {
        return Int.PackedDataLength
    }
    
    public var packedHeaderData: [NSData] {
        return [NSData()]
    }
    
    public var packedBodyData: [NSData] {
        var num: Int = self
        return [NSData(bytes: &num, length: sizeof(Int))]
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
        
        return { data in
            // unpack data as Int
            var value: Int = 0
            let data: NSData = data.subdataWithRange(NSMakeRange(0, sizeof(Int)))
            data.getBytes(&value, length: sizeof(Int))
            return value
        }
    }
}

extension UInt: Packable {
    
    public var packedDataLength: Int {
        return self.packedIDLength + sizeof(UInt)
    }
    
    public var packedHeaderData: [NSData] {
        return [NSData()]
    }
    
    public var packedBodyData: [NSData] {
        var value: UInt = self
        return [NSData(bytes: &value, length: sizeof(UInt))]
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
     
        return { data in
            // unpack data as UInt
            var value: UInt = 0
            let data: NSData = data.subdataWithRange(NSMakeRange(0, sizeof(UInt)))
            data.getBytes(&value, length: sizeof(UInt))
            return value
        }
    }
}

extension Float: Packable {
    
    public var packedDataLength: Int {
        return self.packedIDLength + sizeof(Float)
    }
    
    public var packedHeaderData: [NSData] {
        return [NSData()]
    }
    
    public var packedBodyData: [NSData] {
        var value: Float = self
        return [NSData(bytes: &value, length: sizeof(Float))]
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
        
        return { data in
            // unpack data as Float
            var value: Float = 0
            let data: NSData = data.subdataWithRange(NSMakeRange(0, sizeof(Float)))
            data.getBytes(&value, length: sizeof(Float))
            return value
        }
    }
}

extension Double: Packable {
    
    public var packedDataLength: Int {
        return self.packedIDLength + sizeof(Double)
    }
    
    public var packedHeaderData: [NSData] {
        return [NSData()]
    }
    
    public var packedBodyData: [NSData] {
        var value: Double = self
        return [NSData(bytes: &value, length: sizeof(Double))]
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
    
        return { data in
            // unpack data as Double
            var value: Double = 0
            let data: NSData = data.subdataWithRange(NSMakeRange(0, sizeof(Double)))
            data.getBytes(&value, length: sizeof(Double))
            return value
        }
    }
}

extension String: Packable {
    
    public var packedDataLength: Int {
        return self.packedIDLength + Int.PackedDataLength + self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    }
    
    public var packedHeaderData: [NSData] {
        let length: Int = self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        return [length.packedData]
    }
    
    public var packedBodyData: [NSData] {
        guard let data = self.dataUsingEncoding(NSUTF8StringEncoding) else {
            return [NSData()]
        }
        return [data]
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
        
        return { data in
            
            // get length of string
            let lengthData: NSData = data.subdataWithRange(NSMakeRange(0, Int.PackedDataLength))
            let length: Int = Monaka.unpack(data: lengthData) as! Int
            
            // unpack data as String
            let textRange = NSMakeRange(Int.PackedDataLength, length)
            let textData = data.subdataWithRange(textRange)
            let text = NSString(data: textData, encoding: NSUTF8StringEncoding) as? String ?? ""
            return text
        }
    }
}

protocol ArrayType { }

extension Array: Packable, ArrayType {
    
    public static var packedIdentifier: String {
        return "Array"
    }
    
    public var packedIdentifier: String {
        return "Array"
    }

    public func packable() -> [Packable] {
        return self.flatMap {
            switch $0 {
            case is NSNumber:
                return ($0 as! NSNumber).swiftyValue as? Packable
            case is NSString:
                return ($0 as! NSString) as String
            default:
                return $0 as? Packable
            }
        }
    }
    
    public var packedDataLength: Int {
        let packables: [Packable] = self.packable()
        let elementsLength: Int = packables.reduce(0, combine: {
            $0 + $1.packedDataLength
        })
        return self.packedIDLength + Int.PackedDataLength*(1+packables.count) + elementsLength
    }
    
    public var packedIDLength: Int {
        return sizeof(UInt8) + self.packedIdentifier.characters.count
    }
    
    public var packedHeaderData: [NSData] {
        let packables: [Packable] = self.packable()
        let count: NSData = packables.count.packedData
        let data: [NSData] = packables.map { element in
            return element.packedDataLength
        }.map { length in
            return length.packedData
        }
        return [count] + data
    }
    
    public var packedBodyData: [NSData] {
        let packables: [Packable] = self.packable()
        let data: [NSData] = packables.map { element in
            return element.packedData
        }
        return data
    }
    
    public var packedData: NSData {
        let data: NSMutableData = NSMutableData(data: self.packedIdentifierData)
        for subdata in self.packedHeaderData + self.packedBodyData {
            data.appendData(subdata)
        }
        return NSData(data: data)
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
        
        return { data in
            
            // get number of elements
            let countData = data.subdataWithRange(NSMakeRange(0, Int.PackedDataLength))
            let count: Int = Monaka.unpack(data: countData) as! Int
            
            let subdata: NSData = data.subdataWithRange(NSMakeRange(Int.PackedDataLength, data.length - Int.PackedDataLength))
            let splitData: NSData.SplitData = subdata.split(length: Int.PackedDataLength*count)
            
            // get lengths of each elements
            let lengths: [Int] = splitData.former.splitIntoSubdata(lengths: [Int](count: count, repeatedValue: Int.PackedDataLength)).map { element in
                return Monaka.unpack(data: element) as! Int
            }
            
            // unpack each elements
            let elements: [Packable] = splitData.latter.splitIntoSubdata(lengths: lengths).flatMap { element in
                return Monaka.unpack(data: element)
            }
            
            return elements
        }
    }
    
    public static func activatePack() {
        Monaka.registerUnpackProcedure(identifier: self.packedIdentifier, procedure: self.unpackProcedure)
    }
}

protocol DictionaryType { }

extension Dictionary: Packable, DictionaryType {
    
    public static var packedIdentifier: String {
        return "Dictionary"
    }
    
    public var packedIdentifier: String {
        return "Dictionary"
    }

    public func packable() -> [String: Packable] {
        
        var packable: [String: Packable] = [:]
        for (label, value) in self {
            if let label = label as? String, value = value as? Packable {
                packable[label] = value
            }
        }
        return packable
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
        
        // number of pair of key, value
        let count: NSData = Int(packable.keys.count).packedData
        
        // lengths of each key data
        let keys: [NSData] = packable.keys.map { key in
            return key.packedDataLength
        }.map { (length: Int) in
            return length.packedData
        }
        
        // lengths of each value data
        let values: [NSData] = packable.values.map { value in
            return value.packedDataLength
        }.map { (length: Int) in
            return length.packedData
        }
        
        return [count] + keys + values
    }
    
    public var packedBodyData: [NSData] {
        
        let packable: [String: Packable] = self.packable()
        
        let keys: [NSData] = packable.keys.map { key in
            return key.packedData
        }
        let values: [NSData] = packable.values.map { value in
            return value.packedData
        }
        return keys + values
    }
    
    public static var unpackProcedure: (data: NSData) -> Packable? {
        
        return { data in
            
            // get number of pair of key, value
            let countData = data.subdataWithRange(NSMakeRange(0, Int.PackedDataLength))
            let count: Int = Monaka.unpack(data: countData) as! Int
            
            let subdata: NSData = data.subdataWithRange(NSMakeRange(Int.PackedDataLength, data.length - Int.PackedDataLength))
            let splitData: NSData.SplitData = subdata.split(length: Int.PackedDataLength*count*2)
            
            // get lengths of each data
            let lengths: [Int] = splitData.former.splitIntoSubdata(lengths: [Int](count: count*2, repeatedValue: Int.PackedDataLength)).map { element in
                return Monaka.unpack(data: element) as! Int
            }
            
            let bodyParts: [NSData] = splitData.latter.splitIntoSubdata(lengths: lengths)
            
            // get keys and values
            let keys: [String] = bodyParts[0..<count].flatMap { data in
                return Monaka.unpack(data: data) as? String
            }
            let values: [Packable] = bodyParts[count..<count*2].flatMap { data in
                return Monaka.unpack(data: data)
            }
            
            // get result dictionary
            var dictionary: [String: Packable] =  [String: Packable]()
            keys.enumerate().forEach { index, key in
                dictionary[key] = values[index]
            }
            
            return dictionary
        }
    }
    
    public static func activatePack() {
        Monaka.registerUnpackProcedure(identifier: self.packedIdentifier, procedure: self.unpackProcedure)
    }
}

// MARK: NSNumber Extension

private extension NSNumber {
    
    // Reference: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    
    /// Return converted value to swifty value
    var swiftyValue: Any? {
        
        guard let objCType: String = String.fromCString(self.objCType) else {
            return nil
        }
        
        switch objCType {
        case "q":
            return self as Int
        case "Q":
            return self as UInt
        case "f":
            return self as Float
        case "d":
            return self as Double
        default:
            return nil
        }
    }
}

// MARK: NSData Extension

internal extension NSData {
    
    typealias SplitData = (former: NSData, latter: NSData)
    
    func split(length length: Int) -> SplitData {
        let former: NSData = self.subdataWithRange(NSMakeRange(0, length))
        let latter: NSData = self.subdataWithRange(NSMakeRange(length, self.length - length))
        return (former: former, latter: latter)
    }
    
    func splitIntoSubdata(lengths lengths: [Int]) -> [NSData] {
        
        let data: NSData = NSData(data: self)
        var result: [NSData] = [NSData]()
        
        var position: Int = 0
        for length in lengths {
            let range: NSRange = NSMakeRange(position, length)
            result.append(data.subdataWithRange(range))
            position = position + length
        }
        return result
    }
}
