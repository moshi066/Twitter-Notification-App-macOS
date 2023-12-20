//
//  NewsUseCase.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation
import Combine

public class NewsUseCase {

    private let newsRepository: NewsRepository

    public init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }

    public func execute(_ count: Int?, _ token: String?) -> AnyPublisher<[NewsEntity], Error> {
        return newsRepository.getNewsAsync(count, token)
    }
}
