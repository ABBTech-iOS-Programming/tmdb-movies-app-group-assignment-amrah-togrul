//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//


struct MovieDetails: Decodable {
    let id: Int
    let title: String
    let overview: String?
    let runtime: Int?
    let releaseDate: String?
    let voteAverage: Double
    let genres: [Genre]
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case runtime
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genres
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
