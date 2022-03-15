//
//  SplashRouter.swift
//  Movies
//
//  Created by Sulfah on 07/12/2021.
//

import Foundation

class SplashRouter: SplashRouterProtocol{
    
    var view: UIViewController!
    
    init(viewController: UIViewController? = nil){
        self.view = viewController
    }
    
    static func createModule()->UIViewController{
        let view = SplashViewController()
        let router = SplashRouter(viewController: view)
        let presenter = Splashpresenter()
        let interactor = SplashInteractor()
        
        view.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToMain() {
        let vc = MainRouter.createModule(asAGuest: false)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        view.present(nav, animated: true)
    }
    
}
