//
//  SplashProtocols.swift
//  Movies
//
//  Created by Sulfah on 07/12/2021.
//

import Foundation



protocol SplashViewProtocol{
    var presenter: SplashPresenterToView! {get set}
}

protocol SplashPresenterProtocol{
    var router: SplashRouterProtocol! {get set}
}

protocol SplashPresenterToView{
    func onFinishedAnimation()
}


protocol SplashRouterProtocol{
    var view:UIViewController! {get set}
    func navigateToMain()
}


