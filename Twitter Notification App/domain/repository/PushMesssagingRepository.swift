//
//  PushMesssagingRepository.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/24/23.
//

import Foundation
import Combine

public protocol PushMessagingRepository {
    func registerAsync(registrationToken: String) -> AnyPublisher<Bool, Error>
}
