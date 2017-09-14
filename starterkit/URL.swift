//
//  URL.swift
//  starterkit
//
//  Created by Ade Septiadi on 9/13/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation

extension URL{
    public var queryParameters: [String: Any]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: Any]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
