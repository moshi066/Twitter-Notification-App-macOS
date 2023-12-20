//
//  AlertRepository.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import Foundation
import Combine

public protocol AlertRepository {
    func getAlertsAsync(_ count: Int?) -> AnyPublisher<[AlertEntity], Error>
}
