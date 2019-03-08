//
//  LoginResponse.swift
//  TestApp
//
//  Created by Leidy Carolina Zuluaga Bastidas on 7/03/19.
//  Copyright © 2019 intergrupo. All rights reserved.
//

import ObjectMapper

public class LoginResponse : Mappable {
    var success: Bool?
    var authToken: String?
    var email: String?
    var zone: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        success <- map["success"]
        authToken <- map["authToken"]
        email <- map["email"]
        zone <- map["zone"]
    }
    
    init(success: Bool, authToken: String?, email: String?, zone: String?) {
        self.success = success
        self.authToken = authToken
        self.email = email
        self.zone = zone
    }
}
