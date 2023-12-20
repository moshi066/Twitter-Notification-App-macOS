//
//  LoginQuery.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

public struct LoginQuery {
    public var email: String
    public var password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
