//
//  SideMenuRouter.swift
//  Movies
//
//  Created by Amin on 16/06/2022.
//

import Foundation

protocol SideMenuRouterProtocol{
    
}
struct SideMenuRouter:SideMenuRouterProtocol{
    let viewController:UIViewController!
    
    init(view:UIViewController){
        self.viewController = view
    }
    static func createModule()->UIViewController{
        let vc = SideMenuVC()
        let router = SideMenuRouter(view: vc)
        var presenter = SideMenuPresenter(router: router)
        vc.presenter = presenter
        presenter.router = router
        return vc
    }
}

