//
//  Enums.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation

/*
 Enum dari list method yang diperlukan untuk akses server
 */
enum APIMethod:String{
    //post
    case socialLogin = "auth/social_login"
    case emailLogin = "auth/login"
    case register = "auth/register"
    case forgotPassword = "auth/forgot_password"
    case resetPassword = "auth/reset_password"
}
