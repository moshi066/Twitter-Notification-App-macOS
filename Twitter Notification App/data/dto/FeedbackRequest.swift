//
//  FeedbackRequest.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/6/23.
//

import Foundation

struct FeedbackRequest: Encodable {
    let userId: String
    let newsId: String
    let feedbackType: String
    let feebackValue: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case newsId = "news_id"
        case feedbackType = "feedback_type"
        case feebackValue = "feedback_value"
        case token = "token"
    }
}
