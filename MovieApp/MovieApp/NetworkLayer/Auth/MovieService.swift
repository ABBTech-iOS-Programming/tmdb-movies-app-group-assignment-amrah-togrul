//
//  MovieService.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

import Foundation

final class MovieService: MovieServiceProtocol {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func fetchMovieDetail(
        id: Int,
        completion: @escaping (Result<Movie, Error>) -> Void
    ) {
        let endpoint = MovieEndpoint.getMovieDetail(id: id)

        networkService.request(endpoint) { (result: Result<Movie, NetworkError>) in
            switch result {
            case .success(let movie):
                completion(.success(movie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


