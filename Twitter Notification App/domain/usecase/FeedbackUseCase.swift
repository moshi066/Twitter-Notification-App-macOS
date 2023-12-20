//
//  FeedbackUseCase.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/6/23.
//

import Foundation
import Combine

public class FeedbackUseCase {

    private let feedbackRepository: FeedbackRepository

    public init(feedbackRepository: FeedbackRepository) {
        self.feedbackRepository = feedbackRepository
    }

    public func execute(_ newsId: String, _ feedbackType: String, _ feedbackValue: String, _ token: String) -> AnyPublisher<Bool, Error> {
        return feedbackRepository.postFeedbackAsync(newsId: newsId, feedbackType: feedbackType, feedbackValue: feedbackValue, token: token)
    }
}
