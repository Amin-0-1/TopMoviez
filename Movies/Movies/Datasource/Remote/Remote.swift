//
//  Remote.swift
//  Movies
//
//  Created by Sulfah on 15/11/2021.
//

import Foundation
import Moya

protocol RemoteProtocol{
    func fetch<T:Codable>(target:Target,model:T.Type,completion:@escaping (Result<T,MoviesErrors>)->Void)
    func generateToken(target:Target,completion:@escaping (Result<Token,MoviesErrors>)->Void )
}
class Remote: RemoteProtocol{
    
    private var api:MoyaProvider<Target>
    var connectivity:Connectivity!
    
    init(connectivity:Connectivity? = Connectivity.shared){
        api = MoyaProvider<Target>()
        self.connectivity = connectivity
    }
    
    func generateToken(target: Target, completion: @escaping (Result<Token,MoviesErrors>)->Void )  {
        if connectivity.isConnected(){
            api.request(target) { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let response):
                    switch response.statusCode{
                    case 200:
                        guard let token = try? JSONDecoder().decode(Token.self, from: response.data)else {
                            fatalError("unable to decode")
                        }
                        print(token)
                        completion(.success(token))
                    case 401:
                        guard let failure = try? JSONDecoder().decode(Failure.self, from: response.data)else {
                            fatalError("unable to decode")
                        }
                        completion(.failure(.erorr_401(failure.statusMessage)))
                        break
                    case 404:
                        guard let failure = try? JSONDecoder().decode(Failure.self, from: response.data)else {
                            fatalError("unable to decode")
                        }
                        completion(.failure(.error_404(failure.statusMessage)))
                        break
                    default:
                        break
                    }
                    
                }
            }
        }else{
            completion(.failure(.noInternet))
        }
    }
    
    func fetch<T:Codable>(target:Target,model:T.Type,completion: @escaping (Result<T, MoviesErrors>) -> Void) {
        
        if connectivity.isConnected(){
            api.request(target) { result in
                
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let response):
                    switch response.statusCode{
                    case 200:
                         
                        guard let jsonResponse = try? JSONDecoder().decode(T.self, from: response.data) else {
                            fatalError("unable to decode")
                        }
                        print(jsonResponse)
                        completion(.success(jsonResponse))
                        
                    case 401:
                        guard let jsonResponse = try? JSONDecoder().decode(Failure.self, from: response.data) else {
                            fatalError("unable to decode")
                        }
                        print(jsonResponse)
                        completion(.failure(.erorr_401(jsonResponse.statusMessage)))
                        
                    case 404:
                        guard let jsonResponse = try? JSONDecoder().decode(Failure.self, from: response.data) else {
                            fatalError("unable to decode")
                        }
                        print(jsonResponse)
                        completion(.failure(.error_404(jsonResponse.statusMessage)))
                    default:
                        completion(.failure(.error_404("an error occured, please try again later")))

                    }
                }
            }
        }else{
            completion(.failure(.noInternet))
        }
    }
}
