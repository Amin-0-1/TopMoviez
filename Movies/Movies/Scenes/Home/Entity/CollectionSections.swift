//
//  CollectionSections.swift
//  Movies
//
//  Created by Sulfah on 23/11/2021.
//

import Foundation
enum Sections:Int,Hashable{
    case upcoming = 0
    case top
    case popular
    case now
    case latest
    
    var header: String{
        switch self {
        case .upcoming:
            return "Upcoming"
        case .popular:
            return "Popular"
        case .top:
            return "Top Rated"
        case .now:
            return "Now Playing"
        case .latest:
            return "Latest"
        }
    }
}
