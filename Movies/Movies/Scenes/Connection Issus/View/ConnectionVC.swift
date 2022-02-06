//
//  ConnectionVC.swift
//  Movies
//
//  Created by Sulfah on 24/11/2021.
//

import UIKit

class ConnectionVC: UIViewController , ConnectionVCProtocol{
    var presenter: ConnectionPresenterToView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.onScreenAppeared()
    }

}

extension ConnectionVC: ConnectionViewToPresenter{
    
}
