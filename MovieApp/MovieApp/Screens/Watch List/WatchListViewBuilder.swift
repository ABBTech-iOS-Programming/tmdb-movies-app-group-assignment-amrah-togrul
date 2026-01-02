//
//  WatchListViewBuilder.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


final class WatchListViewBuilder {
    func build() -> WatchListViewController {
        let vm = WatchListViewModel()
        let vc = WatchListViewController(viewModel: vm)
        return vc
    }
}