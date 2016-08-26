//
//  PackablesSpec.swift
//  Monaka
//
//  Created by naru on 2016/08/18.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Monaka

class PackablesSpec: QuickSpec {
    
    override func spec() {
     
        describe("packables", closure: {
                    
            describe("Int", closure: {
                
                context("for positive", {
                    it("can be packed and unpacked", closure: {
                        let value: Int = 10
                        let unpacked: Int? = Monaka.unpack(data: (Monaka.pack(value))) as? Int
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for negative", {
                    it("can be packed and unpacked", closure: {
                        let value: Int = -10
                        let unpacked: Int? = Monaka.unpack(data: (Monaka.pack(value))) as? Int
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for zero", {
                    it("can be packed and unpacked", closure: {
                        let value: Int = 0
                        let unpacked: Int? = Monaka.unpack(data: (Monaka.pack(value))) as? Int
                        expect(unpacked).to(equal(value))
                    })
                })
            })
            
            describe("UInt", closure: {
                
                it("can be packed and unpacked", closure: {
                    let value: UInt = 10
                    let unpacked: UInt? = Monaka.unpack(data: (Monaka.pack(value))) as? UInt
                    expect(unpacked).to(equal(value))
                })
            })
            
            describe("Float", closure: {
                
                context("for positive", {
                    it("can be packed and unpacked", closure: {
                        let value: Float = 10.0
                        let unpacked: Float? = Monaka.unpack(data: (Monaka.pack(value))) as? Float
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for negative", {
                    it("can be packed and unpacked", closure: {
                        let value: Float = -10.0
                        let unpacked: Float? = Monaka.unpack(data: (Monaka.pack(value))) as? Float
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for zero", {
                    it("can be packed and unpacked", closure: {
                        let value: Float = 0.0
                        let unpacked: Float? = Monaka.unpack(data: (Monaka.pack(value))) as? Float
                        expect(unpacked).to(equal(value))
                    })
                })
            })
            
            describe("Double", closure: {
                
                context("for positive", {
                    it("can be packed and unpacked", closure: {
                        let value: Double = 10.0
                        let unpacked: Double? = Monaka.unpack(data: (Monaka.pack(value))) as? Double
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for negative", {
                    it("can be packed and unpacked", closure: {
                        let value: Double = -10.0
                        let unpacked: Double? = Monaka.unpack(data: (Monaka.pack(value))) as? Double
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for zero", {
                    it("can be packed and unpacked", closure: {
                        let value: Double = 0.0
                        let unpacked: Double? = Monaka.unpack(data: (Monaka.pack(value))) as? Double
                        expect(unpacked).to(equal(value))
                    })
                })
            })
            
            describe("String", closure: {
                
                context("for normal", {
                    it("can be packed and unpacked", closure: {
                        let value: String = "packed string"
                        let unpacked: String? = Monaka.unpack(data: (Monaka.pack(value))) as? String
                        expect(unpacked).to(equal(value))
                    })
                })
                
                context("for zero length", {
                    it("can be packed and unpacked", closure: {
                        let value: String = ""
                        let unpacked: String? = Monaka.unpack(data: (Monaka.pack(value))) as? String
                        expect(unpacked).to(equal(value))
                    })
                })
            })
            
            describe("Array", closure: {
                
                context("for 1-dimension array", {
                    it("can be packed and unpacked", closure: {
                        let value: [Packable] = [1, 2, 3, 4, 5]
                        let unpacked: [Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [Packable]
                        expect("\(unpacked!)").to(equal("\(value)"))
                    })
                })
                
                context("for multi-dimension array", {
                    it("can be packed and unpacked", closure: {
                        let value: [Packable] = [[1], [1, 2], [1, 2, 3]]
                        let unpacked: [Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [Packable]
                        expect("\(unpacked!)").to(equal("\(value)"))
                    })
                })
                
                context("for complicated 1-dimension array", {
                    it("can be packed and unpacked", closure: {
                        let value: [Packable] = [1, "2", "3"]
                        let unpacked: [Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [Packable]
                        expect("\(unpacked!)").to(equal("\(value)"))
                    })
                })
                
                context("for complicated multi-dimension array", {
                    it("can be packed and unpacked", closure: {
                        
                        let element0: String = "1"
                        let element1: [Int] = [1, 2]
                        let element2: [Any] = [1, "2", "3"]
                        let element3: Float = 4.0
                        let value: [Packable] = [element0, element1, element2, element3]
                        let unpacked: [Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [Packable]
                        
                        expect("\(unpacked![0])").to(equal("\(element0)"))
                        expect("\(unpacked![1])").to(equal("\(element1)"))
                        expect("\(unpacked![2])").to(equal("\(element2)"))
                        expect("\(unpacked![3])").to(equal("\(element3)"))
                    })
                })
            })
            
            describe("Dictionary", closure: {
                
                context("for simple one", {
                    it("can be packed and unpacked", closure: {
                        let value: [String: Packable] = ["1": 1, "2": 2, "3": 3]
                        let unpacked: [String: Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [String: Packable]
                        expect("\(unpacked!)").to(equal("\(value)"))
                    })
                })
                
                context("for complicated one", {
                    it("can be packed and unpacked", closure: {
                        let value: [String: Packable] = ["1": 1, "2": ["2.1": 2.1, "2.2": 2.2], "3": 3.0]
                        let unpacked: [String: Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [String: Packable]
                        expect("\(unpacked!)").to(equal("\(value)"))
                    })
                })
                
                context("for complicated one containing array", {
                    it("can be packed and unpacked", closure: {
                        let value: [String: Packable] = ["1": 1, "2": [1, 2, 3], "3": 3.0]
                        let unpacked: [String: Packable]? = Monaka.unpack(data: (Monaka.pack(value))) as? [String: Packable]
                        expect("\(unpacked!)").to(equal("\(value)"))
                    })
                })
            })
        })
    }
}
