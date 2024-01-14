//
//  MovieService.swift
//  CinemaTix
//
//  Created by Eky on 06/11/23.
//

import Foundation

class MovieService: BaseService {
    
    private let movieApi = MovieApi()
    
    func getDetail(id: Int, completion: @escaping (Result<MovieDetailModel, AppError>) -> Void) -> Void {
        let url = movieApi.detailById(id)
        request(url: url, expecting: MovieDetailModel.self, completion: completion)
    }
    
    func getCredit(id: Int, completion: @escaping (Result<ResultCreditTMDBModel, AppError>) -> Void) -> Void {
        let url = movieApi.credit(id)
        request(url: url, expecting: ResultCreditTMDBModel.self, completion: completion)
    }
    
    func getImages(id: Int, completion: @escaping (Result<ResultImageTMDBModel, AppError>) -> Void) -> Void {
        let url = movieApi.images(id)
        request(url: url, expecting: ResultImageTMDBModel.self, completion: completion)
    }
    
    func getAllGenres(completion: @escaping (Result<ResultGenreTMBDModel, AppError>) -> Void) -> Void {
        let url = movieApi.genres
        request(url: url, expecting: ResultGenreTMBDModel.self, completion: completion)
    }
    
    func getPopular(page: Int? = nil, completion: @escaping (Result<[MovieModel]?, AppError>) -> Void) -> Void {
        let url = movieApi.popular(page: page ?? 1)
        request(url: url, expecting: ResultMovieTMDBModel<MovieModel>.self) { result in
            switch result {
            case .success(let model):
                let movies = model.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPlayingNow(page: Int? = nil, completion: @escaping (Result<[MovieModel]?, AppError>) -> Void) -> Void {
        let url = movieApi.playingNow(page: page ?? 1)
        request(url: url, expecting: ResultMovieTMDBModel<MovieModel>.self) { result in
            switch result {
            case .success(let model):
                let movies = model.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUpComing(page: Int? = nil, completion: @escaping (Result<[MovieModel]?, AppError>) -> Void) -> Void {
        let url = movieApi.upComing(page: page ?? 1)
        request(url: url, expecting: ResultMovieTMDBModel<MovieModel>.self) { result in
            switch result {
            case .success(let model):
                let movies = model.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTopRated(page: Int? = nil, completion: @escaping (Result<[MovieModel]?, AppError>) -> Void) -> Void {
        let url = movieApi.topRated(page: page ?? 1)
        request(url: url, expecting: ResultMovieTMDBModel<MovieModel>.self) { result in
            switch result {
            case .success(let model):
                let movies = model.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getBySearch(query: String, completion: @escaping (Result<[MovieModel]?, AppError>) -> Void) -> Void {
        let url = movieApi.searchByKeywords(query)
        request(url: url, expecting: ResultMovieTMDBModel<MovieModel>.self) { result in
            switch result {
            case .success(let model):
                let movies = model.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDiscover(query: String, completion: @escaping (Result<[MovieModel]?, AppError>) -> Void) -> Void {
        let url = movieApi.discover
        request(url: url, expecting: ResultMovieTMDBModel<MovieModel>.self) { result in
            switch result {
            case .success(let model):
                let movies = model.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

