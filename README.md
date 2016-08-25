<img src="https://github.com/naru-jpn/Monaka/blob/master/Logo.png?raw=true" width="260" />

[![Swift](https://img.shields.io/badge/swift-2.2-orange.svg?style=flat)](#)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](#)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

## Overview

<img src="https://github.com/naru-jpn/Monaka/blob/master/WhatMonaka.png?raw=true" width="700" />

Monaka is a Library to convert swifty values and NSData each other __to support immutable data handling__.

## Usage

### Pack/Unpack Standard Variables

#### 1.Activate

Write activation codes.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
  Monaka.activateStandardPackables(withCustomStructActivations: { /* Write here if you use your struct to pack. */ })
  
  // Other codes...
        
  return true
}
```

#### 2.Pack/Unpack

You can Pack/Unpack `Packable` variable.

```swift
// For example, simple Int variable.
// Pack
let value: Int = 10
let data: NSData = Monaka.pack(value) 
// Unpack
let unpacked = Monaka.unpack(data) as? Int
```

### Using Custom Struct

#### 1.Make a custom struct confirm protocol `CustomPackable`

```swift
// Protocol `CustomPackable`
struct SampleStruct: CustomPackable {

  let id: String

  /* Implementations */
  
  // Implement function ([String : Packable] -> Packable?) named 'restoreProcedure'
  static var restoreProcedure: [String : Packable] -> Packable? = { (dictionary: [String : Packable]) -> Packable? in
        guard let id = dictionary["id"] as? String else {
            return nil
        }
        return SampleStruct1(id: id)
    }
}
```

#### 2.Activate

Activate your custom struct.

```
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
  Monaka.activateStandardPackables(withCustomStructActivations: {
    SampleStruct.activatePack()
  })
  
  // Other codes...
        
  return true
}
```

#### 3.Pack/Unpack

You can Pack/Unpack as standard types.

```
// Pack
let value: SampleStruct = SampleStruct(id: NSUUID().UUIDString)
let data: NSData = Monaka.pack(value) 
// Unpack
let unpacked = Monaka.unpack(data) as? SampleStruct
```

## License

Monaka is released under the MIT license. See LICENSE for details.
