//
//  AuthSessionEntity.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation
public struct AuthSessionEntity: Codable {
    public var accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
    }
}
