//
//  HomeViewBuilder.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


final class HomeViewBuilder {
    func build() -> HomeViewController {
        let vm = HomeViewModel()
        let vc = HomeViewController(viewModel: vm)
        return vc
    }
}
