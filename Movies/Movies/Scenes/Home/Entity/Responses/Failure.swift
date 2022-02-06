//
//  Failure.swift
//  Movies
//
//  Created by Sulfah on 24/01/2022.
//

import Foundation
struct Failure: Codable {
    let statusMessage: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
