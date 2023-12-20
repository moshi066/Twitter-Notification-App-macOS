//
//  NewsRepositoryImpl.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation
import Combine

public class NewsRepositoryImpl: ApiRepository, NewsRepository {
    
    public func getNewsAsync(_ count: Int?, _ token: String?) -> AnyPublisher<[NewsEntity], Error> {
        Deferred {
            Future<[NewsEntity], Error> { [weak self] promise in
                self?.getNews(count, token) { result, error in
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
    
    private func getNews(_ count: Int?, _ token: String?, block: @escaping ([NewsEntity], Error?) -> Void) {
        var queryItems = [URLQueryItem]()

        if let n = count {
            queryItems.append(URLQueryItem(name: "n", value: String(n)))
        }
        
        if let token = token {
            queryItems.append(URLQueryItem(name: "token", value: token))
        }
        
        let urlRequest = self.urlRequest(
            httpMethod: "GET",
            path: "get-latest-news",
            queryItems: queryItems,
            accessToken: "0MdQ7jAoAfs0JV0MMbkBK8O2YsyTILM7K4I6CwXzVlo"
        )

        self.invoke(urlRequest: urlRequest) { (response: [NewsDto]?, error: Error?) in
            if let error = error {
                block([], error)
                return
            }
            guard let response = response else {
                block([], nil)
                return
            }
            let news = response.map { $0.model }
            block(news, nil)
        }
    }
    
    
}

