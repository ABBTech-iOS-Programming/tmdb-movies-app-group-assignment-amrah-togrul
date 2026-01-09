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
    var categoryMovies: [Movie] = []
    var currentCategory: MovieCategory = .nowPlaying
    let filterCategories = MovieCategory.filterCategories
    
    var onTrendingMoviesUpdated: () -> Void = {}
    var onCategoryMoviesUpdated: () -> Void = {}
    var onError: (String) -> Void = { _ in }

    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMovies(_ category: MovieCategory) {
        networkService.request(category.endpoint) {
            [weak self] (result: Result<MoviesResponse, NetworkError>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if category == .trending {
                        self.trendingMovies = response.results
                        self.onTrendingMoviesUpdated()
                    } else {
                        self.currentCategory = category
                        self.categoryMovies = response.results
                        self.onCategoryMoviesUpdated()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let errorMessage = "Failed to fetch \(category.title) movies: \(error.localizedDescription)"
                    print("❌", errorMessage)
                    self.onError(errorMessage)
                }
            }
        }
    }
    
    func fetchTrendingMovies() {
        fetchMovies(.trending)
    }
}
