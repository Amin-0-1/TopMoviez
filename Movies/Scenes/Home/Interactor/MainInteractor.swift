//
//  MainViewInteractor.swift
//  Movies
//
//  Created by Sulfah on 11/11/2021.
//

import Foundation

class MainInteractor{
    
    var remote: RemoteProtocol!
    weak var presenter: MainPresenterToInteractor!
    
    required init(remote: RemoteProtocol) {
        self.remote = remote
    }
    
    private func generatePostersPathes(toMovies movies :inout [Movie]){
        for (index,_) in movies.enumerated(){
            guard let poster = movies[index].posterPath else {
                guard let poster2 = movies[index].backdropPath else {  continue  }
                movies[index].posterPath = Target.image(poster2).fullPath
                continue
            }
            movies[index].posterPath = Target.image(poster).fullPath
            continue
        }
    }
}

extension MainInteractor: MainInteractorToPresenter{
    func generateToken() {
        remote.generateToken(target: .token) {[weak self] token in
            guard let self = self else {return}
            
            switch token{
                
            case .success(let token):
                self.presenter.onFinishGeneratingToken(token:token)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            
        }
        
    }
    func fetch(endPoint: Targets,page: Int) {
        
        let target = getApiTarget(fromTarget: endPoint, andPage: page)
        
        switch target {
            
        case .popular(_),.upcoming(_),.top(_),.now(_):
            
            remote.fetch(target: target, model: MoviesAPI.self) { result in
                switch result{
                case .success(let moviesApi):
                    var data = moviesApi.results
                    switch endPoint {
                    case .upcoming:
                        self.generatePostersPathes(toMovies: &data)
                        self.presenter.onFinishFetchingUpcoming(withData: data)
                    default:
                        self.generatePostersPathes(toMovies: &data)
                        self.presenter.onFinishFetching(withData: data)
                    }
                case .failure(let error):
                    self.presenter.onFinishFetching(withError: error)
                }
                
            }
        case .latest:
            remote.fetch(target: target, model: Movie.self) { result in
                
                switch result{
                case .success(let movie):
                    var data = [movie]
                    switch endPoint {
                    case .upcoming:
                        self.generatePostersPathes(toMovies: &data)
                        self.presenter.onFinishFetchingUpcoming(withData: data)
                    default:
                        self.generatePostersPathes(toMovies: &data)
                        self.presenter.onFinishFetching(withData: data)
                    }
                case .failure(let error):
                    self.presenter.onFinishFetching(withError: error)
                }
                
            }
        default:
            break
        }
        
    }
    
    private func getApiTarget(fromTarget target:Targets,andPage page: Int)->Target{
        switch target {
        case .popular:
            return .popular(page)
        case .upcoming:
            return .upcoming(page)
        case .latest:
            return .latest
        case .top:
            return .top(page)
        case .now:
            return .now(page)
        }
    }
}
