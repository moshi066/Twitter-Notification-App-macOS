//
//  NewsDto.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

struct NewsDto: Decodable {
    var id: Int
    var _id: String?
    var username: String?
    var name: String?
    var icon: String?
    var title: String?
    var body: String?
    var image: String?
    var time: Date?
    var url: String?
    var link: String?
    var point: Int?
}

extension NewsDto {
    var model: NewsEntity {
        NewsEntity(
            id: id,
            _id: _id ?? "",
            username: username ?? "",
            name: name ?? "",
            icon: URL(string: icon ?? ""),
            title: title ?? "",
            body: body ?? "",
            image: URL(string: image ?? ""),
            time: time ?? Date(),
            url: URL(string: url ?? ""),
            link: URL(string: link ?? ""),
            point: point ?? 0
        )
    }
}
