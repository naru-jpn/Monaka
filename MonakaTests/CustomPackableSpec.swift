//
//  CustomPackableSpec.swift
//  Monaka
//
//  Created by naru on 2016/08/19.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Monaka

private struct SampleStruct1: CustomPackable, Equatable {

    let name: String
    let number: Int
    
    static var restoreProcedure: [String : Packable] -> Packable? = { (dictionary: [String : Packable]) in
        guard let name = dictionary["name"] as? String, let number = dictionary["number"] as? Int else {
            return nil
        }
        return SampleStruct1(name: name, number: number)
    }
}

private func ==(lhs: SampleStruct1, rhs: SampleStruct1) -> Bool {
    return lhs.name == rhs.name && lhs.number == rhs.number
}

private struct SampleStruct2: CustomPackable, Equatable {
    
    let name: String
    let numbers: [Int]
    
    static var restoreProcedure: [String : Packable] -> Packable? = { (dictionary: [String : Packable]) in
        guard let name = dictionary["name"] as? String, let numbers = dictionary["numbers"] as? [Packable] else {
            return nil
        }
        return SampleStruct2(name: name, numbers: numbers.flatMap{ $0 as? Int })
    }
}

private func ==(lhs: SampleStruct2, rhs: SampleStruct2) -> Bool {
    return lhs.name == rhs.name && lhs.numbers == rhs.numbers
}

class CustomPackableSpec: QuickSpec {
    
    override func spec() {
        
        describe("SampleStruct1", {
            
            beforeEach {
                Monaka.activateStandardPackables(withCustomStructActivations: {
                    SampleStruct1.activatePack()
                })
            }
            
            it("can be packed and unpacked", closure: {
                let name: String = "name"
                let number: Int = 10
                let value: SampleStruct1 = SampleStruct1(name: name, number: number)
                let unpacked: SampleStruct1? = Monaka.unpack(data: (Monaka.pack(value))) as? SampleStruct1
                expect(unpacked!).to(equal(value))
            })
        })
        
        describe("SampleStruct2", {
            
            beforeEach {
                Monaka.activateStandardPackables(withCustomStructActivations: {
                    SampleStruct2.activatePack()
                })
            }
            
            it("can be packed and unpacked", closure: {
                let name: String = "name"
                let numbers: [Int] = [1, 2, 3]
                let value: SampleStruct2 = SampleStruct2(name: name, numbers: numbers)
                let unpacked: SampleStruct2? = Monaka.unpack(data: (Monaka.pack(value))) as? SampleStruct2
                expect(unpacked!).to(equal(value))
            })
        })
    }
}
