//
//  SplashInteractor.swift
//  Movies
//
//  Created by Sulfah on 13/03/2022.
//

import Foundation

class SplashInteractor:SplashInteractorProtocol{
    var presenter:SplashPresenterToInteractor!
    func getUserStatus() {
        presenter.onGettingUserStatus(isFirst: true)
    }
}
