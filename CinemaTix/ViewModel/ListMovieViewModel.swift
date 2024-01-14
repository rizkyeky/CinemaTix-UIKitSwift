//
//  ListViewModel.swift
//  CinemaTix
//
//  Created by Eky on 27/12/23.
//

import Foundation

enum ListMovieType: Int {
    case recommanded
    case upcoming
    case topRated
}

class ListMovieViewModel: BaseViewModel {
    
    private let movieService = MovieService()
    
    public var moviesTemp: [MovieModel] = []
    
    public var currentPage = 1
    
    public func getListMovie(listType: ListMovieType, completion: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
        switch listType {
        case .recommanded:
            getPopularMovies(completion: { self.moviesTemp.append(contentsOf: $0)
                completion()
            }, onError: onError)
        case .upcoming:
            getUpComingMovies(completion: { self.moviesTemp.append(contentsOf: $0)
                completion()
            }, onError: onError)
        case .topRated:
            getTopRatedMovies(completion: { self.moviesTemp.append(contentsOf: $0)
                completion()
            }, onError: onError)
        }
        currentPage += 1
    }
    
    private func getTopRatedMovies(completion: @escaping ([MovieModel]) -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getTopRated(page: currentPage) { result in
            switch result {
            case .success(let models):
                completion(models ?? [])
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    private func getUpComingMovies(completion: @escaping ([MovieModel]) -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getUpComing(page: currentPage) { result in
            switch result {
            case .success(let models):
                completion(models ?? [])
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    private func getPopularMovies(completion: @escaping ([MovieModel]) -> Void, onError: ((Error) -> Void)? = nil) {
        movieService.getPopular(page: currentPage) { result in
            switch result {
            case .success(let models):
                completion(models ?? [])
            case .failure(let error):
                onError?(error)
            }
        }
    }
}
