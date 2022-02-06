//
//  Token.swift
//  Movies
//
//  Created by Sulfah on 24/01/2022.
//

import Foundation

struct Token: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
