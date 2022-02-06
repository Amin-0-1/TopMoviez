//
//  Errors.swift
//  Movies
//
//  Created by Sulfah on 15/11/2021.
//

import Foundation

enum MoviesErrors: Error,CustomStringConvertible{
        
    case erorr_401(String)
    case error_404(String)
    case noInternet
    var description: String{
        switch self {
        case .erorr_401(let string):
            return string
        case .error_404(let string):
            return string
        case .noInternet:
            return "No Internet connection, Please try again later..."
        }
    }
}
