//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

import Foundation

enum SearchMovieEndpoint {
    case searchMovie(query: String, page: Int = 1)
}

extension SearchMovieEndpoint: Endpoint {
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .searchMovie:
            return "/search/movie"
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
        switch self {
        case .searchMovie(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "include_adult", value: "false"),
            ]
        }
    }

    var HTTPBody: Encodable? { nil }
}
