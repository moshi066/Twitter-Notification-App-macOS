//
//  FeedbackRepository.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/6/23.
//

import Foundation
import Combine

public protocol FeedbackRepository {
    func postFeedbackAsync(newsId: String, feedbackType: String, feedbackValue: String, token: String) -> AnyPublisher<Bool, Error>
}
