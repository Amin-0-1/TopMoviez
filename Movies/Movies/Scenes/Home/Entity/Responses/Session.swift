//
//  Session.swift
//  Movies
//
//  Created by Sulfah on 10/02/2022.
//

// MARK: - Session
struct Session: Codable {
    let success: Bool
    let sessionID: String?

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
