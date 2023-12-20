//
//  AlertDto.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import Foundation

struct AlertDto: Decodable {
    var alert_id: Int
    var token: String?
    var alert_time: Date?
    var market_score: Double?
}

extension AlertDto {
    var model: AlertEntity {
        AlertEntity(
            id: alert_id,
            marketScore: market_score ?? 0.0,
            alertTime: alert_time ?? Date(),
            token: token ?? ""
        )
    }
}
