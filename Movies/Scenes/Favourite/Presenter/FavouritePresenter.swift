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
    private var favourites:[FavouriteMovie]!
    
    init(){
        favourites = []
    }
}

extension FavouritePresenter: FavouritePresenterToViewProtocol{
    
    func onScreenAppeared() {
        interactor.onScreenAppeared()
    }
    
    func onBackButtonPressed() {
        router.pop()
    }
    
    func getFavsCount() -> Int {
        return favourites.count
    }
    
    func getModel(forIndex index: Int) -> FavouriteMovie {
        return favourites[index]
    }
    
}

extension FavouritePresenter: FavouritePresenterToInteractorProtocol{
    func onFinishFetching(withData data: [FavouriteMovie]) {
        favourites = data
        view.onFinishFetching()
    }
    
    
}
