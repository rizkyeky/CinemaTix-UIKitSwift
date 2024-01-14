//
//  HomeViewModel.swift
//  CinemaTix
//
//  Created by Eky on 14/12/23.
//

import Foundation
//import RxSwift

class HomeViewModel: BaseViewModel {
    
    private let movieService = MovieService()
    
    var playingNowMovies: [MovieModel]?
    var popularMovies: [MovieModel]?
    var topRatedMovies: [MovieModel]?
    var upComingMovies: [MovieModel]?
    
    func getCredit(id: Int, completion: @escaping (([CastModel]) -> Void), onError: ((Error) -> Void)? = nil) {
        movieService.getCredit(id: id) { result in
            switch result {
            case .success(let models):
                if let casts = models.cast {
                    completion(casts.sliceArrayWithMax(5))
                }
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    func getDetailMovie(id: Int, completion: @escaping ((MovieDetailModel) -> Void), onError: ((Error) -> Void)? = nil) {
        movieService.getDetail(id: id) { result in
            switch result {
            case .success(let model):
                completion(model)
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    func getPlayingNowMovies(completion: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getPlayingNow() { result in
            switch result {
            case .success(let models):
                self.playingNowMovies = models?.sliceArrayWithMax(5)
                completion()
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    func getPopularMovies(completion: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getPopular() { result in
            switch result {
            case .success(let models):
                self.popularMovies = models?.sliceArrayWithMax(5)
                completion()
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    
    func getTopRatedMovies(completion: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getTopRated() { result in
            switch result {
            case .success(let models):
                self.topRatedMovies = models?.sliceArrayWithMax(5)
                completion()
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    func getUpComingMovies(completion: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getUpComing() { result in
            switch result {
            case .success(let models):
                self.upComingMovies = models?.sliceArrayWithMax(5)
                completion()
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    func getAllMovies(completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getPlayingNowMovies {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTopRatedMovies {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getUpComingMovies {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
}
