//
//  RegisterTokenRequest.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/24/23.
//

import Foundation

struct RegisterTokenRequest: Encodable {
    let userId: Int
    let token: String
    let deviceType: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case token = "token"
        case deviceType = "device_type"
    }
    
}
