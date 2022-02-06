//
//  DetailsProtocols.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import Foundation

//MARK: view
protocol DetailsViewProtocol{
    var presenter: DetailsPresenterToView! {get set}
}
protocol DetailsViewToPresenter:BaseView,AnyObject{
    func onFinishFetching(movieDetails details:MovieDetailsAPI)
    func playVideo(withObj obj:Video)
    func onFinishCheckFavourite()
    
}


//MARK: presenter
protocol DetailsPresenterProtocol{
    var view: DetailsViewToPresenter! {get set}
    var interactor: DetailsInteractorToPresenter! {get set}
    var router: DetailsRouterToPresenter! {get set}
}
protocol DetailsPresenterToView{
    var posterPath:String? {get set}
    var genresCount:Int {get}
    var video:Video? {get}
    var isLiked:Bool! {get}
    
    func onScreenAppeared()
    func onPlayingVideo()
    func getGener(withIndex index:Int)->String
    func toggleLike()
}
protocol DetailsPresenterToInteractor: AnyObject{
    func onFinishFetchingDetails(withMovie movie:MovieDetailsAPI,andVideos videos:VideosAPI?)
    func onFinishFetching(withError error:String)
    func onCheckedFavourite(withResult result: Bool)
}

//MARK: interactor
protocol DetailsInteractorProtocol{
    var presenter: DetailsPresenterToInteractor! {get set}
}
protocol DetailsInteractorToPresenter{
    func getMovieDetails(withId id: Int)
    func saveMovieToFavourite(movieId:Int)
    func removeMovieFromFavourite(movieId:Int)
    func checkFavourite(forMovieId id:Int)
}

//MARK: Router
protocol DetailsRouter{
    var view:UIViewController! {get set}
    init(viewController:UIViewController)
}

protocol DetailsRouterToPresenter{
    func pop()
    func navigateToVideoScreen(withID id:String)
}

