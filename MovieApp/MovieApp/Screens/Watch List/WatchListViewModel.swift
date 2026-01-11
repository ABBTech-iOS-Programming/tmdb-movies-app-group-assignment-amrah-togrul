//
//  WatchListViewModel.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


final class WatchListViewModel {
    private(set) var movies: [Movie] = []

        var onUpdate: () -> Void = {}

        func loadWatchlist() {
            movies = WatchlistManager.shared.getAll()
            onUpdate()
        }

        func numberOfItems() -> Int {
            movies.count
        }

        func movie(at index: Int) -> Movie {
            movies[index]
        }

}
