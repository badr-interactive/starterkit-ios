//
//  ProfileRealm.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import RealmSwift

class ProfileRealm{
    class func saveOrUpdate(profile: Profile){
        let realm = try! Realm()
        try! realm.write {
            realm.add(profile, update: true)
        }
    }
    
    class func getData()->Profile{
        let realm = try! Realm()
        var profile = Profile()
        let profiles = realm.objects(Profile.self)
        for account in profiles {
            profile = account as Profile
        }
        return profile
    }
    
    class func deleteprofile(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Profile.self))
        }
    }
    
    class func serializeprofile(_ profileDict: NSDictionary) -> Profile{
        let profile = Profile()
        
        if let email = profileDict.value(forKey: "email") as? String {
            profile.email = email
        }
        
        if let id = profileDict.value(forKey: "id") as? String {
            profile.id = id
        }
        
        if let name = profileDict.value(forKey: "name") as? String {
            profile.name = name
        }
        
        if let access_token = profileDict.value(forKey: "access_token") as? String {
            profile.access_token = access_token
        }
        
        if let photo = profileDict.value(forKey: "photo") as? String {
            profile.photo = photo
        }
        
        return profile
    }
}
