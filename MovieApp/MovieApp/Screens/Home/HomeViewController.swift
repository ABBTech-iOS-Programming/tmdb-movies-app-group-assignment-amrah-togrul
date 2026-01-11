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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.font = .app(.poppinsSemiBold(size: 18))
        label.textColor = .white
        return label
    }()
    
    //Search bar as a Button
    private lazy var searchBarAsButton: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToSearchMovieScreen)))
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = .app(.poppinsRegular(size: 14))
        label.textColor = .tertiary
        return label
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .tertiary
        return imageView
    }()
    
    //Trending movies
    private let trendingMoviesLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = .app(.montserratSemiBold(size: 20))
        label.textColor = .white
        return label
    }()
    
    private lazy var categoriesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let spacing: CGFloat = 8.0
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
        
        let spacing: CGFloat = 16.0
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
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
    
    //Category & Its list
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
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TrendingMoviesCell.self, forCellWithReuseIdentifier: TrendingMoviesCell.reuseIdentifier)
        collectionView.backgroundColor = .primary
        return collectionView
    }()
    
    private var selectedGenreMoviesListHeightConstraint: Constraint?
        
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
            guard let self = self else { return }
            self.selectedGenreMoviesList.reloadData()
            
            // Update height after reload
            DispatchQueue.main.async {
                self.updateCollectionViewHeight()
            }
        }
        
        viewModel.onError = { errorMessage in
            print("Error: \(errorMessage)")
            // TODO: Show error to user
        }
    }
    
    private func loadInitialData() {
        viewModel.fetchTrendingMovies()
        viewModel.fetchMovies(.nowPlaying)
        
        DispatchQueue.main.async { [weak self] in
            self?.categoriesView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    private func updateCollectionViewHeight() {
        guard let layout = selectedGenreMoviesList.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let itemHeight = layout.itemSize.height
        let spacing = layout.minimumLineSpacing
        let sectionInset = layout.sectionInset
        
        let numberOfItems = CGFloat(viewModel.categoryMovies.count)
        let numberOfColumns: CGFloat = 3
        let numberOfRows = ceil(numberOfItems / numberOfColumns)
        
        let totalHeight = (numberOfRows * itemHeight) +
                         ((numberOfRows - 1) * spacing) +
                         sectionInset.top +
                         sectionInset.bottom
        
        selectedGenreMoviesListHeightConstraint?.update(offset: totalHeight)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchBarAsButton)
            make.leading.equalTo(24)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchBarAsButton)
            make.width.height.equalTo(16)
            make.trailing.equalTo(-24)
        }
        
        searchBarAsButton.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(24)
            make.height.equalTo(42)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        trendingMoviesLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBarAsButton.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        trendingMoviesList.snp.makeConstraints { make in
            make.top.equalTo(trendingMoviesLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(210)
        }
        
        categoriesView.snp.makeConstraints { make in
            make.top.equalTo(trendingMoviesList.snp.bottom).offset(24)
            make.leading.equalTo(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        selectedGenreMoviesList.snp.makeConstraints { make in
            make.top.equalTo(categoriesView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            selectedGenreMoviesListHeightConstraint = make.height.equalTo(600).constraint
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func setupSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [searchLabel, searchIcon].forEach(searchBarAsButton.addSubview)
        [headerLabel, searchBarAsButton, trendingMoviesLabel, trendingMoviesList, categoriesView, selectedGenreMoviesList].forEach(contentView.addSubview)
    }
    
    @objc private func navigateToSearchMovieScreen() {
        let vc = SearchViewBuilder().build()
        tabBarController?.selectedIndex = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let searchVC = vc as? SearchViewController {
                searchVC.focusSearchBar()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch collectionView.tag {

        case 0:
            let movieId = viewModel.trendingMovies[indexPath.item].id
            let vc = MovieDetailViewController(movieId: movieId)
            navigationController?.pushViewController(vc, animated: true)

        case 1:
            let selectedCategory = viewModel.filterCategories[indexPath.item]
            viewModel.fetchMovies(selectedCategory)

        case 2:
            let movieId = viewModel.categoryMovies[indexPath.item].id
            let vc = MovieDetailViewController(movieId: movieId)
            navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return viewModel.trendingMovies.count
        case 1:
            return viewModel.filterCategories.count
        case 2:
            return viewModel.categoryMovies.count
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        switch collectionView.tag {

        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendingMoviesCell.reuseIdentifier,
                for: indexPath
            ) as! TrendingMoviesCell
            cell.config(with: viewModel.trendingMovies[indexPath.item])
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoiresCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! CategoiresCollectionViewCell
            cell.config(with: viewModel.filterCategories[indexPath.item])
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendingMoviesCell.reuseIdentifier,
                for: indexPath
            ) as! TrendingMoviesCell
            cell.config(with: viewModel.categoryMovies[indexPath.item])
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}
