# DataStore

A simple storage solution for Swift, using Property Wrappers.

Use something like this, preferably a dedicated DataStore.swift file in your project:
```swift
extension DataStore {
    struct Settings {
        @Storage(key: "aUniqueKeyPlease!", defaultValue: .aCaseOfYourEnum)
        var someSettingValue: SomeEnum
        
        @Storage(key: "For real, please use unique keys.", defaultValue: .aCaseOfYourOtherEnum)
        var anotherSettingValue: SomeOtherEnum
    }
    
    struct SomeOtherPartOfYourApp {
        @Storage(key: "Use better names than these too.", defaultValue: "")
        var someString: String
        
        @Storage(key: "Like… seriously. Don't name them like this.", defaultValue: nil)
        var someIntMaybe: Int?
        
        @Storage(key: "somePartOfYourApp-aGoodName", defaultValue: [1, 2, 3])
        var aGoodName: [Int]
    }
}
```

It's similar to SwiftUI's `@AppStorage`, but not limited to primatives, as it works with any `Codable` type.

---
###### Based on something I most likely found on StackOverflow a while back. If you happen to recognize it, create an issue and I'll gladly give credit!
