//
//  FavouriteInteractor.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import Foundation
import RealmSwift


class FavouriteInteractor: FavouriteInteractorProtocol{
    
    private var dataSource: FavDBProtocol!
    private var remote:RemoteProtocol!
    private var group = DispatchGroup()
    private var movies = [Movie]()
    var presenter: FavouritePresenterToInteractorProtocol!
    init(dataSource:FavDBProtocol?,remote:RemoteProtocol?){
        self.dataSource = dataSource
        self.remote = remote
    }
    
    func onScreenAppeared() {
        let objects = dataSource.getAllFavourites()
        getFavouriteMovies(withObjects: objects)
    }
    func deleteFavourite(id: Int) {
        dataSource.removeFavourite(forId: id)
    }
    private func getFavouriteMovies(withObjects objects:[FavouriteMovie]){
        
        objects.forEach { movie in
            group.enter()
            self.remote.fetch(target: .details(movie.id), model: Movie.self) { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movie):
                    
                    self.movies.append(movie)
                }
                self.group.leave()
            }
        }
        group.notify(queue: .main) {
            preparePosterPathes(toMovies: &self.movies)
            self.presenter.onFinishFetching(withData: self.movies)
            self.movies = []
        }
    }
    
}



