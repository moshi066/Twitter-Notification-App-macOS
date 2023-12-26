//
//  PushMessagingRepositoryImpl.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/24/23.
//

import Foundation
import Combine

public class PushMessagingRepositoryImpl: ApiRepository, PushMessagingRepository {

    public func register(registrationToken: String, block: @escaping (Bool, Error?) -> Void) {
        var urlRequest = self.urlRequest(
            httpMethod: "POST",
            path: "add-token"
        )

        let requestBody = RegisterTokenRequest(
            userId: 0, token: registrationToken, deviceType: "OSX"
        )
        do {
            urlRequest.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("ERROR: Unable to register '\(registrationToken)' push messaging token due error: \(error.localizedDescription)")
            block(false, nil)
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

    public func registerAsync(registrationToken: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future<Bool, Error> { [weak self] promise in
                self?.register(registrationToken: registrationToken) { result, error in
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
}
