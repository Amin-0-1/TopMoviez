//
//  FavouritePresenter.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import Foundation

class FavouritePresenter{
    var interactor:FavouriteInteractorProtocol!
    weak var view:FavouriteViewToPresenter!
    var router:FavouriteRouter!
    private var favouriteMovies:[Movie]!
    init(){
        favouriteMovies = []
    }
}

extension FavouritePresenter: FavouritePresenterToViewProtocol{

    func onScreenAppeared() {
        view.loading(status: true)
        interactor.onScreenAppeared()
    }
    
    func onBackButtonPressed() {
        router.pop()
    }
    
    func getFavsCount() -> Int {
        return favouriteMovies.count
    }
    
    func getModel(forIndex index: Int) -> Movie {
        return favouriteMovies[index]
    }
    func onUserSelectItem(atIndex index: Int) {
        
        let movie = favouriteMovies[index]
        router.navigateToDetails(withId: movie.id, andPosterPath: movie.posterPath)
    }
    
    
}

extension FavouritePresenter: FavouritePresenterToInteractorProtocol{
    func onFinishFetching(withData data: [Movie]) {
        favouriteMovies = data
        view.onFinishFetching()
        view.loading(status: false)
    }
}
