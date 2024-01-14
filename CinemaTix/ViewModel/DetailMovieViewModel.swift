//
//  HomeViewModel.swift
//  CinemaTix
//
//  Created by Eky on 14/12/23.
//

import Foundation

class DetailMovieViewModel: BaseViewModel {
    
    private let movieService = MovieService()
    
    func getCasts(id: Int, completion: @escaping (([CastModel]) -> Void), onError: ((Error) -> Void)? = nil) {
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
    
    func getImages(id: Int, completion: @escaping (([ImageTmdb]) -> Void), onError: ((Error) -> Void)? = nil) {
        movieService.getImages(id: id) { result in
            switch result {
            case .success(let model):
                if let images = model.backdrops {
                    completion(images.sliceArrayWithMax(5))
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
}
