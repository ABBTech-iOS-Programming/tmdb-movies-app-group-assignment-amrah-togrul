//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private var viewModel: SearchViewModel
    
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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.layer.cornerRadius = 16
        searchBar.barTintColor = .primary
        searchBar.tintColor = .primary
        searchBar.backgroundColor = .primary

        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    private lazy var searchedMoviesList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 20, right: 22)
        
        let width = UIScreen.main.bounds.width - 44
        layout.itemSize = CGSize(width: width, height: 140)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SearchedMoviesCollectionViewCell.self, forCellWithReuseIdentifier: SearchedMoviesCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .primary
        return collectionView
    }()
    
    //Empty State
    private let emptyStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let emptyStateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "empty_search")
        return imageView
    }()
    
    private let emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "We are sorry, we can not find the movie :("
        label.font = .app(.montserratSemiBold(size: 16))
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let emptyStateBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Find your movie by Type title, categories, years, etc"
        label.font = .app(.montserratSemiBold(size: 12))
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var searchedMoviesListHeightConstraint: Constraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.onSearchedMoviesUpdated = { [weak self] in
            guard let self = self else { return }
            self.searchedMoviesList.reloadData()
            self.updateEmptyStateVisibility()
            self.updateCollectionViewHeight()
        }
        
        viewModel.onError = { errorMessage in
            print("Error: \(errorMessage)")
            // TODO: Show error alert to user
        }
    }
    
    //MARK: Private methods
    private func setupUI() {
        view.backgroundColor = .primary
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Search"
        searchBar.delegate = self
        setupSubview()
        setupConstraints()
        updateEmptyStateVisibility()
    }
    
    private func updateEmptyStateVisibility() {
        if viewModel.searchedMovies.count == 0 {
            emptyStateStackView.isHidden = false
        } else {
            emptyStateStackView.isHidden = true
        }
    }
    
    private func updateCollectionViewHeight() {
        guard let layout = searchedMoviesList.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let itemHeight = layout.itemSize.height
        let spacing = layout.minimumLineSpacing
        let sectionInset = layout.sectionInset
        
        let numberOfItems = CGFloat(viewModel.searchedMovies.count)
        
        let totalHeight = (numberOfItems * itemHeight) +
                         ((numberOfItems - 1) * spacing) +
                         sectionInset.top +
                         sectionInset.bottom
        
        searchedMoviesListHeightConstraint?.update(offset: totalHeight)
        
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
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(50)
        }
        
        emptyStateStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        emptyStateImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(76)
        }
        
        searchedMoviesList.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            searchedMoviesListHeightConstraint = make.height.equalTo(600).constraint
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [searchBar, emptyStateStackView, searchedMoviesList].forEach(contentView.addSubview)
        [emptyStateImage, emptyStateTitleLabel, emptyStateBodyLabel].forEach(emptyStateStackView.addArrangedSubview(_:))
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchedMoviesCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchedMoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.config(with: viewModel.searchedMovies[indexPath.row])
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    //TODO: Add click action to details screen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.searchedMovies[indexPath.row]
        print("Selected movie: \(movie.title)")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.isSearchActive = false
            viewModel.fetchSearchedMovies(searchedText: searchText)
        } else {
            viewModel.isSearchActive = true
            viewModel.fetchSearchedMovies(searchedText: searchText)
        }
    }
    
    func focusSearchBar() {
        searchBar.becomeFirstResponder()
    }
}
