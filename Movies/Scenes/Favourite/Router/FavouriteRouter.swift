//
//  FavouriteRouter.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import Foundation

class FavouriteRouter: FavouriteRouterProtocol{
    var viewController: UIViewController!
    
    init(vc:UIViewController){
        self.viewController = vc
    }
    static func createModule()->UIViewController{
        let vc = FavouriteVC()
        let presenter = FavouritePresenter()
        let interactor = FavouriteInteractor(dataSource: FavouriteDB.shared,remote: Remote())
        let router = FavouriteRouter(vc: vc)
        
        vc.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = vc
        interactor.presenter = presenter
        return vc
        
    }
    func pop() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    
    
}
