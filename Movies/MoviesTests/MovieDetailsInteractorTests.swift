//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Sulfah on 07/12/2021.
//

import XCTest
@testable import Movies

var exp : XCTestExpectation?
class MovieDetailsInteractorTests: XCTestCase {

    override func setUpWithError() throws {
        exp = expectation(description: "waiting")
    }

    override func tearDownWithError() throws {
        exp = nil
    }

    func testGetMovieDetailsFailure(){
        
        let remote = MockRemoteDatasource(isSuccess: false,error: .erorr_401("error_401"))
        
        let interactor = MovieDetailsInteractor(remote: remote)
        let presenter = MockMovieDetailsPresenter()
        
        interactor.presenter = presenter 
        interactor.getMovieDetails(withId: 2)
        
        waitForExpectations(timeout: 2)
    }
    
    func testGetMovieDetailsSuccessWithoutVid(){
        
        let isVid = false
        let remote = MockRemoteDatasource(isSuccess: true,error: nil,vid:isVid)
        let interactor = MovieDetailsInteractor(remote: remote)
        let presenter = MockMovieDetailsPresenter(vid: isVid)
        
        interactor.presenter = presenter
        interactor.getMovieDetails(withId: 2)
        
        waitForExpectations(timeout: 2)
    }
}


class MockMovieDetailsPresenter : DetailsPresenterToInteractor{
    
    var vid : Bool!
    init(vid:Bool? = false){
        self.vid = vid
    }

    
    func onFinishFetchingDetails(withMovie movie: MovieDetailsAPI, andVideos videos: VideosAPI?) {
        exp?.fulfill()
        
        if vid{
            XCTAssertNotNil(videos)
        }else{
            XCTAssertNil(videos)
        }
    }
    
    func onFinishFetching(withError error: String) {
        exp?.fulfill()
        XCTAssertEqual(error, MoviesErrors.erorr_401("error_401").description)
    }
}


class MockRemoteDatasource: RemoteProtocol{
    var isSuccess:Bool!
    var error:MoviesErrors!
    var vid:Bool!
    
    init(isSuccess:Bool,error: MoviesErrors?,vid:Bool? = false){
        self.isSuccess = isSuccess
        self.error = error
        self.vid = vid
    }
    func fetch<T>(target: Target, model: T.Type, completion: @escaping (Result<T, MoviesErrors>) -> Void) where T : Decodable, T : Encodable {
        
        switch target {

        case .details(_):
                
            if isSuccess{
                
                guard let obj = try? JSONDecoder().decode(T.self, from: target.sampleData) else {fatalError("unable to decode")}
                completion(.success(obj))
            }else{
                switch error {
                case .erorr_401(let string):
                    completion(.failure(.erorr_401(string)))
                case .error_404(let string):
                    completion(.failure(.error_404(string)))
                case .noInternet:
                    completion(.failure(.noInternet))
                case .none:
                    break
                }
            }
            
        case .videos(_):
            if vid{
                guard let obj = try? JSONDecoder().decode(T.self, from: target.sampleData) else {fatalError("unable to decode")}
                
                completion(.success(obj))
            }else{
                completion(.failure(.noInternet))
            }
        default: break
        }
        
    }
}
