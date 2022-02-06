//
//  FavouriteInteractor.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import Foundation
import RealmSwift


class FavouriteInteractor: FavouriteInteractorProtocol{
    
    private var dataSource: FavDBProtocol!
    private var remote:RemoteProtocol!
    var presenter: FavouritePresenterToInteractorProtocol!
    init(dataSource:FavDBProtocol?,remote:RemoteProtocol?){
        self.dataSource = dataSource
        
    }
    
    func onScreenAppeared() {
        let objects = dataSource.getAllFavourites()
        let dispatchGroup = DispatchGroup()

//        for i in objects{
//            dispatchGroup.enter()
//            self.remote.fetch(target: , model: <#T##(Decodable & Encodable).Protocol#>, completion: <#T##(Result<Decodable & Encodable, Errors>) -> Void#>)
//        }
        presenter.onFinishFetching(withData:objects)
    }
    
}



