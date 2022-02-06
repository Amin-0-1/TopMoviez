//
//  DatabaseProtocol.swift
//  Movies
//
//  Created by Sulfah on 28/12/2021.
//

import Foundation
import RealmSwift

protocol FavDBProtocol{
    func saveFavourite(withId id:Int)
    func removeFavourite(forId id: Int)
    func checkFavourite(forMovieId id:Int)->Bool
    func getAllFavourites()-> [FavouriteMovie]
}

class FavouriteDB: FavDBProtocol{

    private static var realm = try! Realm()
    static let shared = FavouriteDB()
    private init(){}
    
    func saveFavourite(withId id:Int){
        do{
            try Self.realm.write {
                let obj = FavouriteMovie()
                obj.id = id
                Self.realm.add(obj)
                print(NSHomeDirectory())
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    func checkFavourite(forMovieId id: Int)->Bool {
        guard Self.realm.objects(FavouriteMovie.self).where({$0.id == id}).first != nil else {return false}
        return true
    }
    func removeFavourite(forId id: Int) {
        guard let obj = Self.realm.objects(FavouriteMovie.self).where({$0.id == id}).first else {return}
        
        do{
            Self.realm.beginWrite()
            Self.realm.delete(obj)
            try Self.realm.commitWrite()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getAllFavourites()->[FavouriteMovie] {
        let objs = Self.realm.objects(FavouriteMovie.self)
        return Array(objs)
    }
    
}
