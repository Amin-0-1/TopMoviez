//
//  MovieDetailsInteractor.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import Foundation

class MovieDetailsInteractor: DetailsInteractorProtocol{
    weak var presenter: DetailsPresenterToInteractor!
    private var remote: RemoteProtocol!
    private var movieDetails: MovieDetailsAPI!
    private var favDB: FavDBProtocol!
    init(remote:RemoteProtocol? = Remote(),database: FavDBProtocol? = nil){
        self.remote = remote
        guard let database = database else {
            self.favDB = FavouriteDB.shared
            return
        }
        self.favDB = database
    }

}

extension MovieDetailsInteractor: DetailsInteractorToPresenter{
    func checkFavourite(forMovieId id: Int) {
        let isFav = favDB.checkFavourite(forMovieId:id)
        presenter.onCheckedFavourite(withResult : isFav)
    }
    
    func saveMovieToFavourite(movieId: Int) {
        favDB.saveFavourite(withId: movieId)
    }
    
    func removeMovieFromFavourite(movieId: Int) {
        favDB.removeFavourite(forId: movieId)
    }
    
    func getMovieDetails(withId id: Int) {
        
        remote.fetch(target: .details(id), model: MovieDetailsAPI.self) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .failure(let error):
                print(error.description)
                self.presenter.onFinishFetching(withError: error.description)
            case .success(let movie):
                self.movieDetails = movie
                self.getMovieVideos(withId: id)
                
            }

        }
    }
    
    private func getMovieVideos(withId id:Int){
        remote.fetch(target: .videos(id), model: VideosAPI.self) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .failure(_):
                self.presenter.onFinishFetchingDetails(withMovie: self.movieDetails,andVideos: nil)
            case .success(let vid):
                self.presenter.onFinishFetchingDetails(withMovie: self.movieDetails,andVideos: vid)
            }
        }
    }
}
