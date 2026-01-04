//
//  MovieEndpoint.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

import Foundation

enum MovieWatchListEndpoint {
    //TODO: Need to add accoun id from App Config and Session id
    case addToWatchList(accountId: Int, movieId: Int, add: Bool)
    case getWatchList(accountId: Int)
}

extension MovieWatchListEndpoint: Endpoint {
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .addToWatchList(let accountId, _, _):
            return "/account/\(accountId)/watchlist"
        case .getWatchList(let accountId):
            return "/account/\(accountId)/watchlist/movies"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .addToWatchList:
            return .post
        case .getWatchList:
            return .get
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var queryItems: [URLQueryItem]? { nil }

    var HTTPBody: Encodable? {
        switch self {
        case .addToWatchList(_, let movieId, let add):
            return WatchListRequest(
                media_type: "movie",
                media_id: movieId,
                watchlist: add
            )
        default:
            return nil
        }
    }
}
