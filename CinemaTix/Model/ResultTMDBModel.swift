//
//  ResultTMDBModel.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation

// MARK: - ResultTmDB
struct ResultMovieTMDBModel<T: Codable>: Codable {
    let dates: RangeDates?
    let page: Int?
    let results: [T]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - RangeDates
struct RangeDates: Codable {
    let maximum, minimum: String?
}

struct ResultQueryTMDB: Codable {
    let id: Int?
    let name: String?
}

struct ResultGenreTMBDModel: Codable {
    let genres: [GenreModel]?
}

struct ResultCreditTMDBModel: Codable {
    let id: Int?
    let cast, crew: [CastModel]?
}

struct ResultImageTMDBModel: Codable {
    let backdrops: [ImageTmdb]?
    let id: Int?
    let logos, posters: [ImageTmdb]?
}

struct ImageTmdb: Codable {
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount, width: Int?
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
