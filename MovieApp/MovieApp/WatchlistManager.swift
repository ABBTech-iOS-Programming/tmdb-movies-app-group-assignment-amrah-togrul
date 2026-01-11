//
//  WatchlistManager.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

final class WatchlistManager {

    static let shared = WatchlistManager()
    private init() {}

    private var movies: [Movie] = []

    func add(_ movie: Movie) {
        if !movies.contains(where: { $0.id == movie.id }) {
            movies.append(movie)
        }
    }

    func remove(_ id: Int) {
        movies.removeAll { $0.id == id }
    }

    func contains(_ id: Int) -> Bool {
        movies.contains { $0.id == id }
    }

    func getAll() -> [Movie] {
        movies
    }
}
