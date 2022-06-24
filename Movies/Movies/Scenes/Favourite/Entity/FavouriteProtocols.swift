//
//  FavouriteProtocols.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import Foundation

//MARK: View protocols

protocol FavouriteViewToPresenter:BaseView,AnyObject{
    func onFinishFetching()
    func onEmptyFavourites()
    func onChangingIndecesCount(_ count:Int)
    func removeItemsFromView(withIndeces:[Int])
    func deselectItemsFromView(withIndeces indeces:[Int])
}

//MARK: Presenter protocols

protocol FavouritePresenterToViewProtocol{
    func onBackButtonPressed()
    func onScreenAppeared()
    func getFavsCount()->Int
    func getModel(forIndex index:Int)->Movie
    func onUserSelectItem(atIndex index:Int)
    func onUserWantDelete(index: Int)
    func onUserWantDelete()
    func onUserSelectMultible(withIndex:Int)
    func onUserDeselect(index:Int)
    func deselectAll()
}
protocol FavouritePresenterToInteractorProtocol: AnyObject{
    func onFinishFetching(withData data:[Movie])
}


//MARK: Interactor
protocol FavouriteInteractorProtocol{
    func onScreenAppeared()
    func deleteFavourite(id:Int)
}

//MARK: Router
protocol FavouriteRouterProtocol{
    func pop()
    func navigateToDetails(withId id: Int, andPosterPath path: String?)
}

