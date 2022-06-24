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
    private var multibleSelectionIndeces:[Int]{
        didSet{
            view.onChangingIndecesCount(multibleSelectionIndeces.count)
            multibleSelectionIndeces.forEach{print($0,favouriteMovies[$0].id)}
        }
    }
    init(){
        multibleSelectionIndeces = []
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
    
    func onUserSelectMultible(withIndex index: Int) {
        multibleSelectionIndeces.append(index)
    }
    func onUserDeselect(index: Int) {
        multibleSelectionIndeces.removeAll{$0 == index}
    }
    
    func onUserWantDelete(index: Int) {
        let id = favouriteMovies[index].id
        interactor.deleteFavourite(id:id)
        favouriteMovies.remove(at: index)
        favouriteMovies.isEmpty ? view.onEmptyFavourites() : nil
    }
    
    func onUserWantDelete() {
        
        let ids = multibleSelectionIndeces.map{favouriteMovies[$0].id}
        ids.forEach { id in
            interactor.deleteFavourite(id: id)
            favouriteMovies.removeAll{$0.id == id}
        }
        view.removeItemsFromView(withIndeces:multibleSelectionIndeces)
        multibleSelectionIndeces.removeAll()
        favouriteMovies.isEmpty ? view.onEmptyFavourites() : nil
    }
    
    func deselectAll() {
        var indeces = [Int]()
        multibleSelectionIndeces.forEach {indeces.append($0)}
        multibleSelectionIndeces.removeAll()
        view.deselectItemsFromView(withIndeces:indeces)
    }

    
}

extension FavouritePresenter: FavouritePresenterToInteractorProtocol{
    func onFinishFetching(withData data: [Movie]) {
        favouriteMovies = data
        favouriteMovies.forEach{print($0.id)}
        view.onFinishFetching()
        view.loading(status: false)
    }
}
