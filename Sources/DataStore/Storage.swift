import Foundation
import Security

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: "DataStore-" + key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Attempt to convert data to the desired data type
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

@propertyWrapper
struct EncryptedStringStorage {
    
    // Constant Identifiers
    private let userAccount = "AuthenticatedUser"
    private let accessGroup = "SecuritySerivice"

    // Arguments for the keychain queries
    private let kSecClassValue = NSString(format: kSecClass)
    private let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
    private let kSecValueDataValue = NSString(format: kSecValueData)
    private let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    private let kSecAttrServiceValue = NSString(format: kSecAttrService)
    private let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
    private let kSecReturnDataValue = NSString(format: kSecReturnData)
    private let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String? {
        get {
            // Instantiate a new default keychain query
            // Tell the query to return a result
            // Limit our results to one item
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key, userAccount, kCFBooleanTrue ?? true, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

            var dataTypeRef: AnyObject?

            // Search for the keychain items
            let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
            var contentsOfKeychain: String? = nil

            if status == errSecSuccess {
                if let retrievedData = dataTypeRef as? Data {
                    contentsOfKeychain = String(data: retrievedData, encoding: .utf8)
                }
            } else {
                print("Nothing was retrieved from the keychain. Status code \(status)")
            }

            return contentsOfKeychain
        }
        set {
            let dataFromString: Data = newValue?.data(using: .utf8, allowLossyConversion: false) ?? Data()

            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

            // Delete any existing items
            SecItemDelete(keychainQuery as CFDictionary)

            // Add the new keychain item
            SecItemAdd(keychainQuery as CFDictionary, nil)
        }
    }
}
