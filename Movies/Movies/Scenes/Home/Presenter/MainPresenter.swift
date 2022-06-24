//
//  MainViewPresenter.swift
//  Movies
//
//  Created by Sulfah on 11/11/2021.
//

import Foundation


class MainPresenter: MainPresenterProtocol {
    var isPaginate: Bool!
    private var isSearching:Bool = false
    private var searchResults = [Movie]()
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
            view.paginate(status: isPaginate)
        }
        interactor.fetch(endPoint: endPoint,page: page)
        
    }
}
extension MainPresenter: MainPresenterToView{

    
    func getModel(forIndex index: Int) -> Movie {
        return searchResults[index]
    }
    

    var mainTitles: [String]! {
        return ["Top Rated","Popular","Now Playing","Latest"]
    }
    
    func getSearchCount()->Int{
        return searchResults.count
    }
    func onStartPoint() {
        self.fetch(endPoint: .upcoming, paging: false)
    }
    
    func onSearch() {
        isSearching = !isSearching
        resetPages()
        if isSearching{
            view.onSearching()
        }else{
            searchResults = []
            view.dismissSearching()
        }
    }
    
    func searching(forText text: String) {

        view.loading(status: true)
        interactor.searching(forText: text)
    }
    func fetch(withSelectedIndex index: Int,paging: Bool) {
        guard !isSearching else {return}
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
        if isSearching{
            let movie = searchResults[index.item]
            router.navigateToDetails(withId: movie.id,andPosterPath: movie.posterPath)
        }else{
            guard let movie = datasource.itemIdentifier(for: index) else {return}
            router.navigateToDetails(withId: movie.id,andPosterPath: movie.posterPath)
        }
    }
}
extension MainPresenter: MainPresenterToInteractor{
    func onEmptySearch() {
        view.loading(status: false)
        searchResults = []
        view.onFinishSearching()
        view.onEmptySearch()
    }
    
    func onFinishSearching(withData data: [Movie]) {
        view.loading(status: false)
        searchResults = data
        view.onFinishSearching()
    }
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
