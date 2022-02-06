//
//  MovieDetailsPresenter.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import Foundation

class MovieDetailspresenter: DetailsPresenterProtocol{
    weak var view: DetailsViewToPresenter!
    var interactor: DetailsInteractorToPresenter!
    var router: DetailsRouterToPresenter!
    
    private var movieId:Int!
    private var movieDetails:MovieDetailsAPI!{
        didSet{
            self.genresCount = movieDetails.genres.count
        }
    }
    
    var movieVideos:VideosAPI!{
        didSet{
            guard let vid = movieVideos, !vid.results.isEmpty else{return}
            video = vid.results[0]
        }
    }
    
    var posterPath: String?
    var genresCount: Int
    var video: Video?
    var isLiked: Bool!
    
    init(movieId id:Int,andPosterPath path:String?){
        self.movieId = id
        self.posterPath = path
        genresCount = 0
        video = nil
        isLiked = false
    }
}

extension MovieDetailspresenter: DetailsPresenterToView{
    func toggleLike() {
        
        guard let movieId = movieId else {return}
        if !isLiked{
            interactor.saveMovieToFavourite(movieId: movieId)
        }else{
            interactor.removeMovieFromFavourite(movieId: movieId)
        }

        isLiked = !isLiked
        onCheckedFavourite(withResult: isLiked)
    }
    

    func onScreenAppeared() {
        view.loading(status: true)
        interactor.getMovieDetails(withId: movieId)
        checkFavourite(forMovieId: movieId)
    }
    
    private func checkFavourite(forMovieId id:Int){
        interactor.checkFavourite(forMovieId: id)
    }
    
    func getGener(withIndex index: Int) ->String{
        return self.movieDetails.genres[index].name
    }
    
    func onPlayingVideo() {
        guard let video = self.video else {return}
        // play vid on the legacy way aka deeplinking, webview
        view.playVideo(withObj: video)
        
        // play video on the application
        router.navigateToVideoScreen(withID: video.key)
    }
    
    
}

extension MovieDetailspresenter: DetailsPresenterToInteractor{
    func onCheckedFavourite(withResult result: Bool) {
        isLiked = result
        view.onFinishCheckFavourite()
    }
    
    func onFinishFetching(withError error: String) {
        view.loading(status: false)
        view.showError(error: error)
    }
    
    func onFinishFetchingDetails(withMovie movie: MovieDetailsAPI,andVideos videos: VideosAPI?) {
        view.loading(status: false)
        self.movieDetails = movie
        self.movieVideos = videos
        view.onFinishFetching(movieDetails: movie)
    }
    
}
