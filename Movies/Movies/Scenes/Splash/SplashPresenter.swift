//
//  SplashPresenter.swift
//  Movies
//
//  Created by Sulfah on 07/12/2021.
//

import Foundation


class Splashpresenter: SplashPresenterProtocol,SplashPresenterToView{
    
    var router: SplashRouterProtocol!
    var interactor: SplashInteractorProtocol!
    
    func onFinishedAnimation() {
        interactor.getUserStatus()
//        router.navigateToMain()
    }
}

extension Splashpresenter:SplashPresenterToInteractor{
    func onGettingUserStatus(isFirst: Bool) {
//        isFirst ? router.navigateToCredientials() : router.navigateToMain()
        router.navigateToMain()
    }
}
