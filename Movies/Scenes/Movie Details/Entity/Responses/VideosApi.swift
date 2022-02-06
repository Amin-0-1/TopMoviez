//
//  VideosApi.swift
//  Movies
//
//  Created by Sulfah on 06/12/2021.
//

import Foundation

// MARK: - VideosAPI
struct VideosAPI: Codable {
    let id: Int
    let results: [Video]
}

// MARK: - Result
struct Video: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

extension Video{
    var browserURL: URL? {
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var deepLinkURL: URL? {
        return URL(string: "youtube://\(key)")
    }

    var thumbnailURL: URL? {
        return URL(string: "https://img.youtube.com/vi/\(key)/mqdefault.jpg")
    }
}
