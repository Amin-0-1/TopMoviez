//
//  Protocols.swift
//  Movies
//
//  Created by Sulfah on 11/11/2021.
//

import Foundation
import UIKit



//MARK: View
protocol MainViewToPresenter: BaseView,AnyObject{

    func onFinishFetchingUpcoming(withData : [Movie])
    func onFinishFetchingPage(withData page: [Movie] )
    func onFinishFetching(withData:[Movie])
    func onFinishSearching()
    func paginate(status:Bool)
    func onSearching()
    func dismissSearching()
    func onEmptySearch()
}

//MARK: Presenter
protocol MainPresenterToView{
    var mainTitles:[String]! { get }
    func onStartPoint()
    func onSearch()
    func searching(forText text:String)
    func fetch(withSelectedIndex index:Int,paging:Bool)
    func onTappedCell(withIndex index:IndexPath)
    func favButtonPressed()
    func menuButtonPressed()
    func getSearchCount()->Int
    func getModel(forIndex index:Int)->Movie
    var datasource: UICollectionViewDiffableDataSource<Sections,Movie>! {get set}
    
}
protocol MainInteractorToPresenter{
    func fetch(endPoint:Targets,page:Int)
    func searching(forText text:String)
}

protocol MainPresenterProtocol {
    var page: Int! {get set}
    var isPaginate:Bool! {get set}
}




//MARK: Interactor
protocol MainPresenterToInteractor: AnyObject{
    func onFinishFetching(withData data: [Movie])
    func onFinishFetchingUpcoming(withData upcoming: [Movie])
    func onFinishSearching(withData data:[Movie])
    func onFinishFetching(withError error:MoviesErrors)
    func onEmptySearch()
}

//MARK: Router

protocol MainRouterProtocol{
    func navigateToFavourites()
}
protocol MainRouterToPresenter{
    func showConnectionIssues()
    func navigateToDetails(withId:Int,andPosterPath:String?)
    func navigateToFavourites()
    func navigateToSideMenu()
}
