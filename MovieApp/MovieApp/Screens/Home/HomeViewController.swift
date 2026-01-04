//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    
    //MARK: Views
    
    //TODO: Add search field
    //TODO: Add categories filter
    //TODO: Add films list by selected category
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let trentingMoviesLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var trendingMoviesList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let spacing: CGFloat = 30.0
        let itemSize = CGSize(width: 144, height: 210)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 11, bottom: 11, right: spacing)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 0
        collectionView.register(TrendingMoviesCell.self, forCellWithReuseIdentifier: TrendingMoviesCell.reusableCell)
        return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchTrendingMovies()
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    private func setupUI() {
        view.backgroundColor = .primary
        setupSubview()
        setupConstraints()
    }
    
    private func bindViewModel() {
        viewModel.onTrendingMoviesUpdated = { [weak self] in
            guard let self else { return }
            trendingMoviesList.reloadData()
            
        }
    }

    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        trentingMoviesLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(22)

        }
        
        trendingMoviesList.snp.makeConstraints { make in
            make.top.equalTo(trentingMoviesLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
        }
    }

    private func setupSubview() {
        [headerLabel, trentingMoviesLabel, trendingMoviesList].forEach(view.addSubview)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.trendingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMoviesCell.reusableCell, for: indexPath) as? TrendingMoviesCell
        guard let cell else {
            return TrendingMoviesCell()
        }
        cell.config(with: viewModel.trendingMovies[indexPath.row])
        return cell
    }
}
