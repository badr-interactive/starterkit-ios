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
    
    let preference: UserDefaults
    
    // MARK: - Initialization
    
    override init() {
        self.preference = UserDefaults.standard
        
        let cache: URLCache = URLCache(memoryCapacity: 2 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache
        
        super.init()
    }
    
    func isLoggedIn() -> Bool? {
        return preference.object(forKey: "logged_in") as! Bool?
    }
    func setLoginState(value: Bool) {
        preference.set(value, forKey: "logged_in")
    }
}
