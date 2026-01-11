//
//  MovieEndpoint.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

import Foundation

enum MovieEndpoint {
    case getTrendingMovies
    case getNowPlayingMovies
    case getPopularMovies
    case getUpcomingMovies
    case getTopRatedMovies
    case getMovieDetail(id: Int)
}

extension MovieEndpoint: Endpoint {
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
               case .getMovieDetail:
                   return [
                       URLQueryItem(name: "language", value: "en-US")
                   ]
               default:
                   return [
                       URLQueryItem(name: "language", value: "en-US"),
                       URLQueryItem(name: "page", value: "1")
                   ]
               }
    }
    
    var HTTPBody: (any Encodable)? {
        nil
    }
    
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }

    var path: String {
        switch self {
        case .getTrendingMovies:
            return "/trending/movie/day"
        case .getNowPlayingMovies:
            return "/movie/now_playing"
        case .getPopularMovies:
            return "/movie/popular"
        case .getUpcomingMovies:
            return "/movie/upcoming"
        case .getTopRatedMovies:
            return "/movie/top_rated"
        case .getMovieDetail(let id):
                return "/movie/\(id)"
            }
        }
    }
    
    var method: HTTPMethod { .get }

    var headers: [String: String]? { nil }

    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
    }

    var HTTPBody: Encodable? { nil }

