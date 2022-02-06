//
//  SplashPresenter.swift
//  Movies
//
//  Created by Sulfah on 07/12/2021.
//

import Foundation


class Splashpresenter: SplashPresenterProtocol,SplashPresenterToView{
    
    var router: SplashRouterProtocol!
    
    func onFinishedAnimation() {
        router.navigateToMain()
    }
}
