//
//  Profile.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object{
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var photo: String = ""
    dynamic var email: String = ""
    dynamic var access_token: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
