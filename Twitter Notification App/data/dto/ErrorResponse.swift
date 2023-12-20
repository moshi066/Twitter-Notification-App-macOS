//
//  ErrorResponse.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

struct ErrorResponse: Decodable {
    var detail: String?
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
}
