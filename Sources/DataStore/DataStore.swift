public struct DataStore {
    
}

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
