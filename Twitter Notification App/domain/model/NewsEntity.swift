//
//  NewsEntity.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

public struct NewsEntity: Identifiable, Equatable {
    public var id: Int
    public var _id: String
    public var username: String
    public var name: String
    public var icon: URL?
    public var title: String
    public var body: String
    public var image: URL?
    public var time: Date
    public var url: URL?
    public var link: URL?
    public var point: Int
    public var read: Bool = false
    
    public static func ==(lhs: NewsEntity, rhs: NewsEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
