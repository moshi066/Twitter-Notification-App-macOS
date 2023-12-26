//
//  PushMessagingUseCase.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/24/23.
//

import Foundation
import Combine

public class PushMessagingUseCase {
    private let pushMessagingRepository: PushMessagingRepository

    public init(pushMessagingRepository: PushMessagingRepository) {
        self.pushMessagingRepository = pushMessagingRepository
    }

    public func execute(registrationToken: String) -> AnyPublisher<Bool, Error> {
        pushMessagingRepository.registerAsync(registrationToken: registrationToken)
    }
}
