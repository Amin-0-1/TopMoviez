//
//  MovieDetailsEntity.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import Foundation
import RealmSwift

class FavouriteMovie: Object{
    @Persisted(primaryKey: true)  var id:Int
}
