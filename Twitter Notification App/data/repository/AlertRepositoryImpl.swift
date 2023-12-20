//
//  AlertRepositoryImpl.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import Foundation
import Combine

public class AlertRepositoryImpl: ApiRepository, AlertRepository {
    
    public func getAlertsAsync(_ count: Int?) -> AnyPublisher<[AlertEntity], Error> {
        Deferred {
            Future<[AlertEntity], Error> { [weak self] promise in
                self?.getAlerts(count) { result, error in
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
    
    private func getAlerts(_ count: Int?, block: @escaping ([AlertEntity], Error?) -> Void) {
        var queryItems = [URLQueryItem]()

        if let n = count {
            queryItems.append(URLQueryItem(name: "n", value: String(n)))
        }
        
        let urlRequest = self.urlRequest(
            httpMethod: "GET",
            path: "get-latest-alerts",
            queryItems: queryItems,
            accessToken: "0MdQ7jAoAfs0JV0MMbkBK8O2YsyTILM7K4I6CwXzVlo"
        )

        self.invoke(urlRequest: urlRequest) { (response: [AlertDto]?, error: Error?) in
            if let error = error {
                block([], error)
                return
            }
            guard let response = response else {
                block([], nil)
                return
            }
            let alerts = response.map { $0.model }
            block(alerts, nil)
        }
    }
}

