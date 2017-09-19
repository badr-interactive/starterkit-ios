//
//  Preference.swift
//  Example
//
//  Created by Ade Septiadi on 5/10/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation

class Preference: NSObject{
    static let defaultPreference: Preference = Preference()
    static let ifUniversalLinkEnable = "universal_link"
    static let loginState = "logged_in"
    
    let preference: UserDefaults
    
    // MARK: - Initialization
    
    override init() {
        self.preference = UserDefaults.standard
        
        let cache: URLCache = URLCache(memoryCapacity: 2 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache
        
        super.init()
    }
    
    func getBoolPref(_ key: String) -> Bool? {
        if let value = preference.object(forKey: key) as? Bool{ return value }
        return false
    }
    func setBoolPref(_ key: String, _ value: Bool) {
        preference.set(value, forKey: key)
    }
    
    func getIntPref(_ key: String) -> Int? {
        if let value = preference.object(forKey: key) as? Int{ return value }
        return 0
    }
    func setIntPref(_ key: String, _ value: Int) {
        preference.set(value, forKey: key)
    }
    
    func getStringPref(_ key: String) -> String? {
        if let value = preference.object(forKey: key) as? String{ return value }
        return ""
    }
    func setStringPref(_ key: String, _ value: String) {
        preference.set(value, forKey: key)
    }
}
