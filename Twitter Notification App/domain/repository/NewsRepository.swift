//
//  NewsRepository.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation
import Combine

public protocol NewsRepository {
    func getNewsAsync(_ count: Int?, _ token: String?) -> AnyPublisher<[NewsEntity], Error>
}
