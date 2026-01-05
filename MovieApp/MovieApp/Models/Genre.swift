//
//  Genre.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

struct Genre: Decodable {
    let id: Int
    let name: String
}

enum MovieCategory {
    case trending
    case nowPlaying
    case popular
    case upcoming
    case topRated
    
    var endpoint: MovieEndpoint {
        switch self {
        case .trending:
            return .getTrendingMovies
        case .nowPlaying:
            return .getNowPlayingMovies
        case .popular:
            return .getPopularMovies
        case .upcoming:
            return .getUpcomingMovies
        case .topRated:
            return .getTopRatedMovies
        }
    }
    
    var title: String {
        switch self {
        case .trending:
            return "Trending"
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        }
    }
    
    static var filterCategories: [MovieCategory] {
        [.nowPlaying, .popular, .upcoming, .topRated]
    }
}
