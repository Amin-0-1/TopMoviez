////
////  EndPoints.swift
////  Movies
////
////  Created by Sulfah on 09/11/2021.
////
//
import Foundation
import Moya


private let API_KEY = "7dcf924f19364d108e4d438a072e0996"
private let BASE_URL = "https://api.themoviedb.org/3/"
private let AUTHORIZE = "https://www.themoviedb.org/authenticate/"
private let IMAGE_URL = "https://image.tmdb.org/t/p/original/"
enum Target{
    case image(String)
    case popular(Int)
    case upcoming(Int)
    case latest
    case top(Int)
    case now(Int)
    case details(Int)
    case videos(Int)
    case token
    case authorize(String)
    case movie(Int)
    case search(String)
}
extension Target: TargetType{
    
    var baseURL: URL {
        switch self {
        case .image(_):
            guard let url = URL(string: IMAGE_URL) else {fatalError("url is not valid")}
            return url
        case .authorize:
            guard let url = URL(string: AUTHORIZE) else {fatalError("url is not valid")}
            return url
        default:
            guard let url = URL(string: BASE_URL) else {fatalError("url is not valid")}
            return url
        }
    }
    
    var path: String {
        switch self {
            
        case .image(let path):
            return path
        case .popular:
            return "movie/popular"
        case .upcoming:
            return "movie/upcoming"
        case .latest:
            return "movie/latest"
        case .top:
            return "movie/top_rated"
        case .now:
            return "movie/now_playing"
        case .details(let id):
            return "movie/\(id)"
        case .videos(let id):
            return "movie/\(id)/videos"
        case .token:
            return "authentication/token/new"
        case .authorize(let token):
            return "\(token)"
        case .movie(_):
            return "movie/"
        case .search(_):
            return "search/movie"
        }
    }
    var method: Moya.Method {
        switch self {
//        case .authorize:
//            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .popular(let page):
            return .requestParameters(parameters: ["api_key":API_KEY,"language":"en-US","page":page], encoding: URLEncoding.queryString)
        case .upcoming(let page):
            return .requestParameters(parameters: ["api_key":API_KEY,"language":"en-US","page":page], encoding: URLEncoding.queryString)
        case .top(let page):
            return .requestParameters(parameters: ["api_key":API_KEY,"language":"en-US","page":page], encoding: URLEncoding.queryString)
        case .now(let page):
            return .requestParameters(parameters: ["api_key":API_KEY,"language":"en-US","page":page], encoding: URLEncoding.queryString)
        case .authorize(_):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .search(let text):
            return .requestParameters(parameters: ["api_key":API_KEY,"language":"en-US","query":text], encoding: URLEncoding.queryString)
        default :
            return .requestParameters(parameters: ["api_key":API_KEY,"language":"en-US"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var fullPath:String{
        switch self {
        case .image(let string):
            return baseURL.appendingPathComponent(string).absoluteString
        default:
            return baseURL.appendingPathComponent(path).absoluteString
        }
    }
    var sampleData: Data{
        switch self {

        case .details(let int):

            let obj =  MovieDetailsAPI(adult: .random(), backdropPath: UUID().uuidString, budget: .random(in: 1...10), genres: [Genre(id: 0, name: UUID().uuidString)], homepage: UUID().uuidString, id: int, imdbID: nil, originalLanguage: UUID().uuidString, originalTitle: UUID().uuidString, overview: UUID().uuidString, popularity: .random(in: 0...10), posterPath: nil, releaseDate: UUID().uuidString, revenue: .random(in: 2000...100000), runtime: .random(in: 1...3), spokenLanguages: [SpokenLanguage(englishName: "english", iso639_1: "", name: "")], status: UUID().uuidString, tagline: UUID().uuidString, title: UUID().uuidString, video: .random(), voteAverage: 0.0, voteCount: .random(in: 200...6000))
            
            guard let encoded = try? JSONEncoder().encode(obj) else {fatalError("unable to encode object")}
            return encoded
            
        case .videos(let int):
            let obj = VideosAPI(id: int, results: [Video(iso639_1: "", iso3166_1: "", name: "name", key: "key", site: "youtube", size: 2, type: "", official: true, publishedAt: "", id: "")])
            
            guard let encoded = try? JSONEncoder().encode(obj) else {fatalError("unable to encode object")}
            return encoded
        default:
            return "default".data(using: .utf8)!

        }
    }
}
