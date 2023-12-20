//
//  FeedbackResponse.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/6/23.
//

import Foundation

struct FeedbackResponse: Decodable {
    var status: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}
