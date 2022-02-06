////
////  MockRemote.swift
////  Movies
////
////  Created by Sulfah on 07/12/2021.
////
//
//import Foundation
//
//class MockRemoteDatasource: RemoteProtocol{
//    var isSuccess:Bool!
//    var error:Errors!
//    var vid:Bool!
//    
//    init(isSuccess:Bool,error: Errors?,vid:Bool? = false){
//        self.isSuccess = isSuccess
//        self.error = error
//        self.vid = vid
//    }
//    func fetch<T>(target: Target, model: T.Type, completion: @escaping (Result<T, Errors>) -> Void) where T : Decodable, T : Encodable {
//        
//        switch target {
//
//        case .details(_):
//                
//            if isSuccess{
//                
//                guard let obj = try? JSONDecoder().decode(T.self, from: target.sampleData) else {fatalError("unable to decode")}
//                completion(.success(obj))
//            }else{
//                switch error {
//                case .erorr_401(let string):
//                    completion(.failure(.erorr_401(string)))
//                case .error_404(let string):
//                    completion(.failure(.error_404(string)))
//                case .noInternet:
//                    completion(.failure(.noInternet))
//                case .none:
//                    break
//                }
//            }
//            
//        case .videos(_):
//            if vid{
//                guard let obj = try? JSONDecoder().decode(T.self, from: target.sampleData) else {fatalError("unable to decode")}
//                
//                completion(.success(obj))
//            }else{
//                completion(.failure(.noInternet))
//            }
//        default: break
//        }
//        
//    }
//}
