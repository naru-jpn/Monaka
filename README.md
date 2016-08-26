<img src="https://github.com/naru-jpn/Monaka/blob/master/Logo2.png?raw=true" width="200" />

# Monaka

[![Swift](https://img.shields.io/badge/swift-2.2-orange.svg?style=flat)](#)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](#)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

## Overview

Monaka convert custom struct and fundamental values to NSData (also nested array and dictionary). 

<img src="https://github.com/naru-jpn/Monaka/blob/master/WhatMonaka.png?raw=true" width="600" />

## Installation

### Carthage

```
github "naru-jpn/Monaka"
```

### CocoaPods

```
pod 'Monaka'
```

## Usage

### For Standard Variables

`Packable` variable ⇄ NSData.

```swift
// Pack
let value: Int = 10
let data: NSData = Monaka.pack(value)

// Unpack
let unpacked = Monaka.unpack(data) as? Int
```

### For Custom Struct

#### 1.Make a custom struct confirming protocol `CustomPackable`

```swift
struct Sample: CustomPackable {
    
    let id: String
    
    // Return new struct from applied properties.
    static var restoreProcedure: ([String : Packable] -> Packable?) = { (properties: [String : Packable]) -> Packable? in
        guard let id = properties["id"] as? String else {
            return nil
        }
        return Sample(id: id)
    }
}
```

#### 2.Activate your custom struct.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
  Monaka.activate(Sample)
  
  // Other codes...
        
  return true
}
```

#### 3.Pack/Unpack

You can Pack/Unpack as standard types.

```swift
// Pack
let value: SampleStruct = SampleStruct(id: NSUUID().UUIDString)
let data: NSData = Monaka.pack(value) 
// Unpack
let unpacked = Monaka.unpack(data) as? SampleStruct
```

## License

Monaka is released under the MIT license. See LICENSE for details.
