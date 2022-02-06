//
//  Presenter.swift
//  Movies
//
//  Created by Sulfah on 24/11/2021.
//

import Foundation

class ConnectionPresenter: ConnectionPresenterProtocol{
    var router: ConnectionRouterProtocol!
    var view: ConnectionViewToPresenter!
    
}

extension ConnectionPresenter: ConnectionPresenterToView{
    func onScreenAppeared() {
        let con = Connectivity.shared
        con.getConnectionPath().pathUpdateHandler = { [unowned self] path in
            if path.status == .satisfied{
                router.dismiss()
            }
        }
    }
}
