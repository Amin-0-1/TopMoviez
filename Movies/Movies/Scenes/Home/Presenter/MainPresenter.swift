//
//  MainViewPresenter.swift
//  Movies
//
//  Created by Sulfah on 11/11/2021.
//

import Foundation


class MainPresenter: MainPresenterProtocol {
    var isPaginate: Bool!
    var datasource: UICollectionViewDiffableDataSource<Sections, Movie>!
    var page: Int!{
        willSet{
            print("pages is \(newValue ?? 2)")
        }
    }
    var interactor: MainInteractorToPresenter!
    weak var view: MainViewToPresenter!
    var router: MainRouterToPresenter!
    
    init(){
        resetPages()
    }
    private func resetPages(){
        page = 1
        isPaginate = false
    }
    private func fetch(endPoint: Targets,paging: Bool) {
        
        if paging == true{
            isPaginate = true
            view.paginate(status: true)
        }else{
            view.loading(status: true)
            isPaginate = false
            view.paginate(status: false)
        }
        interactor.fetch(endPoint: endPoint,page: page)
        
    }
}
extension MainPresenter: MainPresenterToView{
    
    var mainTitles: [String]! {
        return ["Top Rated","Popular","Now Playing","Latest"]
    }
    
    func onStartPoint() {
        self.fetch(endPoint: .upcoming, paging: false)
    }
    
    func fetch(withSelectedIndex index: Int,paging: Bool) {
        var endPoint : Targets
        switch index{
        case 0:
            endPoint = .top
        case 1:
            endPoint = .popular
        case 2:
            endPoint = .now
        case 3:
            endPoint = .latest
        default:
            endPoint = .latest
        }
        
        if paging == true && endPoint == .latest{
            view.paginate(status: false)
            return
        }
        
        paging ? page += 1 : resetPages()
        self.fetch(endPoint: endPoint,paging: paging)
        
    }
    func menuButtonPressed() {
        router.navigateToSideMenu()
    }
    func favButtonPressed() {
        router.navigateToFavourites()
    }
    func onTappedCell(withIndex index: IndexPath) {
        guard let movie = datasource.itemIdentifier(for: index) else {return}

        router.navigateToDetails(withId: movie.id,andPosterPath: movie.posterPath)
    }
}
extension MainPresenter: MainPresenterToInteractor{
    
    func onFinishFetchingUpcoming(withData upcoming: [Movie]) {
        view.onFinishFetchingUpcoming(withData: upcoming)
        fetch(endPoint: .top,paging: false)
    }
    func onFinishFetching(withData data: [Movie]) {
        
        if isPaginate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[unowned self] in
//                self.view.loading(status: false)
                view.paginate(status: false)
                view.onFinishFetchingPage(withData: data)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[unowned self] in
                self.view.loading(status: false)
                view.onFinishFetching(withData: data)
            }
        }
        isPaginate = false
    }
    
    func onFinishFetching(withError error: MoviesErrors) {
        if isPaginate{
            view.paginate(status: true)
        }else{
            router.showConnectionIssues()
        }
        isPaginate = false
        view.loading(status: false)
        view.showError(error: error.description)
    }
    
}
