//
//  FilmDetailsBilder.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


final class FilmDetailsBilder {
    func build() -> FilmDetailsViewController {
        let vm = FilmDetailsViewModel()
        let vc = FilmDetailsViewController(viewModel: vm)
        return vc
    }
}