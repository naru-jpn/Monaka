# Monaka
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Overview

Monaka is a Library for iOS to convert swifty values and NSData each other.

## Usage

#### 1.Prepare

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
let unpacked: Int? = Monaka.unpack(data) as? Int
```




