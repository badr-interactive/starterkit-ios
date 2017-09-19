//
//  Enums.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation

enum APIMethod:String{
    //post
    case socialLogin = "auth/social_login"
    case emailLogin = "auth/login"
    case register = "auth/register"
    case forgotPassword = "auth/forgot_password"
    case resetPassword = "auth/reset_password"
}
