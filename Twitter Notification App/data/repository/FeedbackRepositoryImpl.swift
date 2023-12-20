//
//  FeedbackRepositoryImpl.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/6/23.
//

import Foundation
import Combine

public class FeedbackRepositoryImpl: ApiRepository, FeedbackRepository {
    public func postFeedbackAsync(newsId: String, feedbackType: String, feedbackValue: String, token: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future<Bool, Error> { [weak self] promise in
                self?.postFeedback(newsId, feedbackType, feedbackValue, token) { result, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    private func postFeedback(_ newsId: String, _ feedbackType: String, _ feedbackValue: String, _ token: String, block: @escaping (Bool, Error?) -> Void) {

        var urlRequest = self.urlRequest(
            httpMethod: "POST",
            path: "feedback",
            accessToken: "0MdQ7jAoAfs0JV0MMbkBK8O2YsyTILM7K4I6CwXzVlo"
        )
        
        let requestBody = FeedbackRequest(userId: "", newsId: newsId, feedbackType: feedbackType, feebackValue: feedbackValue, token: token
        )
        do {
            urlRequest.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            block(false, error)
            return
        }
        
        self.invoke(urlRequest: urlRequest) { (response: FeedbackResponse?, error: Error?) in
            if let error = error {
                block(false, error)
                return
            }
            guard let response = response else {
                block(false, nil)
                return
            }
            
            block(response.status == "success", nil)
        }
    }
    
}

