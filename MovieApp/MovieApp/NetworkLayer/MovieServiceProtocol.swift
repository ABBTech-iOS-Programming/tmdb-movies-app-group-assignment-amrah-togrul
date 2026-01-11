//
//  MovieServiceProtocol.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovieDetail(
        id: Int,
        completion: @escaping (Result<Movie, Error>) -> Void
    )
}
