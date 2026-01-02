//
//  SearchViewBuilder.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


final class SearchViewBuilder {
    func build() -> SearchViewController {
        let vm = SearchViewModel()
        let vc = SearchViewController(viewModel: vm)
        return vc
    }
}