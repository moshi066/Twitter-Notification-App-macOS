//
//  AlertEntity.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import Foundation

public struct AlertEntity: Identifiable, Equatable {
    public var id: Int
    public var marketScore: Double
    public var alertTime: Date
    public var token: String
    public var probability: String = ""
    public var confidence: String = ""
    public var newsForce: String = ""
    public var buyOrSell: String = ""

    
    public static func ==(lhs: AlertEntity, rhs: AlertEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
