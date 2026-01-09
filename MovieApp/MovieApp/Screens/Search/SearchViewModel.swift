//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//
import Foundation

final class SearchViewModel {
    private let networkService: NetworkService
    
    var isSearchActive: Bool = false
    var searchedMovies: [Movie] = []
    
    var onSearchedMoviesUpdated: () -> Void = {}
    var onError: (String) -> Void = { _ in }

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchSearchedMovies(searchedText: String) {
        guard !searchedText.isEmpty else {
            searchedMovies = []
            DispatchQueue.main.async {
                self.onSearchedMoviesUpdated()
            }
            return
        }
        
        networkService.request(SearchMovieEndpoint.searchMovie(query: searchedText, page: 1)) {
            [weak self] (result: Result<MoviesResponse, NetworkError>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.searchedMovies = response.results
                    self.onSearchedMoviesUpdated()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let errorMessage = "Failed to fetch \(error.localizedDescription)"
                    print("❌", errorMessage)
                    self.onError(errorMessage)
                }
            }
        }
    }
}
