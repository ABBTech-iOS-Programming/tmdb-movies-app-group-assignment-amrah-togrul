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
    //TODO: Setup scroll view
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let trentingMoviesLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var categoriesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let spacing: CGFloat = 8.0
        let itemSize = CGSize(width: 100, height: 40)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing * 2, bottom: spacing, right: spacing * 2)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 1
        collectionView.backgroundColor = .primary
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoiresCollectionViewCell.self, forCellWithReuseIdentifier: CategoiresCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var trendingMoviesList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let spacing: CGFloat = 30.0
        let itemSize = CGSize(width: 144, height: 210)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 11, bottom: 11, right: spacing)
        layout.itemSize = CGSize(width: 144, height: 210)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 0
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TrendingMoviesCell.self, forCellWithReuseIdentifier: TrendingMoviesCell.reuseIdentifier)
        collectionView.backgroundColor = .primary
        return collectionView
    }()
    
    private lazy var selectedGenreMoviesList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let spacing: CGFloat = 16.0
        let horizontalInset: CGFloat = 22.0
        let numberOfColumns: CGFloat = 3
        let totalSpacing = (numberOfColumns - 1) * spacing + (horizontalInset * 2)
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let itemHeight: CGFloat = itemWidth * 1.5
        
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 20, right: horizontalInset)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 2
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TrendingMoviesCell.self, forCellWithReuseIdentifier: TrendingMoviesCell.reuseIdentifier)
        collectionView.backgroundColor = .primary
        return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        loadInitialData()
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
            self?.trendingMoviesList.reloadData()
        }
        
        viewModel.onCategoryMoviesUpdated = { [weak self] in
            self?.selectedGenreMoviesList.reloadData()
        }
        
        viewModel.onError = { errorMessage in
            print("Error: \(errorMessage)")
            // TODO: Show error to user
        }
    }
    
    private func loadInitialData() {
        viewModel.fetchTrendingMovies()
        viewModel.fetchMovies(.nowPlaying)
        categoriesView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
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
            make.height.equalTo(230)
        }
        
        categoriesView.snp.makeConstraints { make in
            make.top.equalTo(trendingMoviesList.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        selectedGenreMoviesList.snp.makeConstraints { make in
            make.top.equalTo(categoriesView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view)
        }
    }

    private func setupSubview() {
        [headerLabel, trentingMoviesLabel, trendingMoviesList, categoriesView, selectedGenreMoviesList].forEach(view.addSubview)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let selectedCategory = viewModel.filterCategories[indexPath.row]
            viewModel.fetchMovies(selectedCategory)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: // Trending movies
            return viewModel.trendingMovies.count
        case 1: // Categories
            return viewModel.filterCategories.count
        case 2: // Category movies
            return viewModel.categoryMovies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMoviesCell.reuseIdentifier, for: indexPath) as? TrendingMoviesCell
            guard let cell else {
                return TrendingMoviesCell()
            }
            cell.config(with: viewModel.trendingMovies[indexPath.row])
            return cell
        } else if  collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoiresCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoiresCollectionViewCell
            guard let cell else {
                return CategoiresCollectionViewCell()
            }
            cell.config(with: viewModel.filterCategories[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMoviesCell.reuseIdentifier, for: indexPath) as? TrendingMoviesCell
            guard let cell else {
                return TrendingMoviesCell()
            }
            cell.config(with: viewModel.categoryMovies[indexPath.row])
            return cell
        }
    }
}
