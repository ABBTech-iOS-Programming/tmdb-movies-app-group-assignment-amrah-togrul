//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

final class MovieDetailViewModel {

    private let movieId: Int
    private let service = MovieService()

    var movieDetail: Movie?
    var onUpdate: () -> Void = {}

    private(set) var isInWatchlist: Bool = false

    init(movieId: Int) {
        self.movieId = movieId
        self.isInWatchlist = WatchlistManager.shared.contains(movieId)
    }

    func fetchMovieDetail() {
        service.fetchMovieDetail(id: movieId) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movieDetail = movie
                self?.onUpdate()
            case .failure(let error):
                print("Movie detail error:", error)
            }
        }
    }

    func toggleWatchlist() {
        guard let movie = movieDetail else { return }

        isInWatchlist.toggle()

        if isInWatchlist {
            WatchlistManager.shared.add(movie)
        } else {
            WatchlistManager.shared.remove(movie.id)
        }
    }
}
