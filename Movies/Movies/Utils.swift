//
//  Utils.swift
//  Movies
//
//  Created by Sulfah on 15/03/2022.
//

import Foundation

private func generatePostersPathes(toMovies movies :inout [Movie]){
    for (index,_) in movies.enumerated(){
        guard let poster = movies[index].posterPath else {
            guard let poster2 = movies[index].backdropPath else {  continue  }
            movies[index].posterPath = Target.image(poster2).fullPath
            continue
        }
        movies[index].posterPath = Target.image(poster).fullPath
        continue
    }
}
