//
//  MovieDetailsRouter.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import Foundation

class MovieDetailsRouter: DetailsRouter{
    var view: UIViewController!
    
    required init(viewController: UIViewController) {
        self.view = viewController
    }
}
extension MovieDetailsRouter: DetailsRouterToPresenter{
    func navigateToVideoScreen(withID id: String) {
        let vc = VideoVC()
        vc.vidID = id
        view.present(vc, animated: true)
    }
    
    static func createModule(withId id: Int,andPosterPath path:String?) -> UIViewController {
        let view = MovieDetailsVC()
        let presenter = MovieDetailspresenter(movieId:id,andPosterPath:path)
        let router = MovieDetailsRouter(viewController: view)
        let interactor = MovieDetailsInteractor()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        return view
    }

    func pop() {
        view.navigationController?.popViewController(animated: true)
    }
}
