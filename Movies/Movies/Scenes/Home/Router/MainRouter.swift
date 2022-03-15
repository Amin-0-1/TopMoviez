//
//  MainViewRouter.swift
//  Movies
//
//  Created by Sulfah on 11/11/2021.
//

import UIKit

class MainRouter: MainRouterProtocol{
    
    var viewController: UIViewController!
    init(view: UIViewController) {
        self.viewController = view
    }
    
    func navigateToFavourites() {
        let vc = FavouriteRouter.createModule()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainRouter : MainRouterToPresenter{

    static func createModule(asAGuest:Bool) -> UIViewController {
        let view = MainViewController() as MainViewController
        let interactor = MainInteractor(remote: Remote())
        let presenter = MainPresenter()
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = MainRouter(view: view)
        interactor.presenter = presenter
        return view
    }
    
    func showConnectionIssues() {
        let vc = ConnectionRouter.createModule()
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }

    func navigateToDetails(withId id: Int,andPosterPath path:String?) {
        let vc = MovieDetailsRouter.createModule(withId: id,andPosterPath: path)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
}
