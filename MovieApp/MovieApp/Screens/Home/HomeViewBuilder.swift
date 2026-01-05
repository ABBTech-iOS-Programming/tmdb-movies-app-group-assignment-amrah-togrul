//
//  HomeViewBuilder.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


final class HomeViewBuilder {
    func build() -> HomeViewController {
        let networkService: NetworkService = DefaultNetworkService()
        let vm = HomeViewModel(networkService: networkService)
        let vc = HomeViewController(viewModel: vm)
        return vc
    }
}
