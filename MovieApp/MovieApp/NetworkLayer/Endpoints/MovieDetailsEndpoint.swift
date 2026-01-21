//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

import Foundation

enum MovieDetailsEndpoint {
    case getMovieDetials(Int)
    case getReviews(Int)
}

extension MovieDetailsEndpoint: Endpoint {
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .getMovieDetials(let id):
            return "/movie-details/\(id)"
        case .getReviews(let id):
            return "/movie/\(id)/reviews"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String: String]? {
        return [
             "Authorization": "Bearer \(AppConfig.tmdbBearerToken)",
             "accept": "application/json"
         ]
    }

    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
    }

    var HTTPBody: Encodable? { nil }
}
