//
//  FavouriteProtocols.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import Foundation

//MARK: View protocols

protocol FavouriteViewToPresenter:AnyObject{
    func onFinishFetching()
}

//MARK: Presenter protocols

protocol FavouritePresenterToViewProtocol{
    func onBackButtonPressed()
    func onScreenAppeared()
    func getFavsCount()->Int
    func getModel(forIndex index:Int)->FavouriteMovie
}
protocol FavouritePresenterToInteractorProtocol: AnyObject{
    func onFinishFetching(withData data:[FavouriteMovie])
}


//MARK: Interactor
protocol FavouriteInteractorProtocol{
    func onScreenAppeared()
}

//MARK: Router
protocol FavouriteRouterProtocol{
    func pop()
}

