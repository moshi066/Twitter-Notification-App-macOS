//
//  AlertUseCase.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import Foundation
import Combine

public class AlertUseCase {

    private let alertRepository: AlertRepository

    public init(alertRepository: AlertRepository) {
        self.alertRepository = alertRepository
    }

    public func execute(_ count: Int?) -> AnyPublisher<[AlertEntity], Error> {
        return alertRepository.getAlertsAsync(count)
    }
}
