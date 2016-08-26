//
//  Sample.swift
//  MonakaExample
//
//  Created by naru on 2016/08/26.
//  Copyright © 2016年 naru. All rights reserved.
//

import Foundation

struct Sample: CustomPackable {
    
    let id: String
    
    static var restoreProcedure: ([String : Packable] -> Packable?) {
        return { dictionary in
            guard let id = dictionary["id"] as? String else {
                return nil
            }
            return Sample(id: id)
        }
    }
}
