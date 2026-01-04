//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//
import Foundation

final class HomeViewModel {
    private let networkService: NetworkService
    
    var trendingMovies: [Movie] = []
    var onTrendingMoviesUpdated: () -> Void = {}

    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchTrendingMovies() {
        networkService.request(MovieEndpoint.getTrendingMovies) { [weak self] (result: Result<[Movie], NetworkError>) in
            
            guard let self else  { return }
            
            switch result {
            case .success(let movies):
                self.trendingMovies = movies
                DispatchQueue.main.async {
                    self.onTrendingMoviesUpdated()
                }
            case .failure(let error):
                print("Log Error: \(error)")
            }
        }
    }
}
