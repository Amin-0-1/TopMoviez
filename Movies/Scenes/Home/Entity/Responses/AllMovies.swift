//
//  MoviesApi.swift
//  Movies
//
//  Created by Sulfah on 09/11/2021.
//

//   let moviesAPI = try? newJSONDecoder().decode(MoviesAPI.self, from: jsonData)

import Foundation


// MARK: - MoviesAPI
struct MoviesAPI: Codable {
    let dates:Dates?
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates,page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates:Codable{
    let maximum:String
    let minimum:String
}

// MARK: - Movie
struct Movie: Codable ,Hashable{
    let adult: Bool
    let backdropPath: String?
//    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    var posterPath : String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    private let uuid = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

