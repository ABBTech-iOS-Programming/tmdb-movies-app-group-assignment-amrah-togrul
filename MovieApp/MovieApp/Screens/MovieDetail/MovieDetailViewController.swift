//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

import UIKit
import SnapKit

final class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let infoContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .primary
        v.layer.cornerRadius = 24
        v.clipsToBounds = true
        return v
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.numberOfLines = 0
        return l
    }()
    
    private let tabContainerView = UIView()
    
    private let aboutButton = UIButton(type: .system)
    private let reviewsButton = UIButton(type: .system)
    private let castButton = UIButton(type: .system)
    
    private let tabUnderlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 1
        return v
    }()
    
    private let overviewLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = .systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    init(movieId: Int) {
        self.viewModel = MovieDetailViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        setupNavigationBar()
        setupTabs()
        setupUI()
        bindViewModel()
        viewModel.fetchMovieDetail()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Detail"
        
        let watchlistButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(didTapWatchlist)
        )
        
        navigationItem.rightBarButtonItem = watchlistButton
    }
    
    @objc private func didTapWatchlist() {
        viewModel.toggleWatchlist()
        updateWatchlistIcon()
    }
    
    private func updateWatchlistIcon() {
        let imageName = viewModel.isInWatchlist ? "bookmark.fill" : "bookmark"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
    private func setupTabs() {
        aboutButton.setTitle("About Movie", for: .normal)
        reviewsButton.setTitle("Reviews", for: .normal)
        castButton.setTitle("Cast", for: .normal)
        
        let buttons = [aboutButton, reviewsButton, castButton]
        for button in buttons {
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        }
        
        aboutButton.setTitleColor(.white, for: .normal)
    }
    
    
    
    
    private func setupUI() {
        
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(infoContainerView)
        
        infoContainerView.addSubview(posterImageView)
        infoContainerView.addSubview(titleLabel)
        infoContainerView.addSubview(tabContainerView)
        infoContainerView.addSubview(overviewLabel)
        
        tabContainerView.addSubview(aboutButton)
        tabContainerView.addSubview(reviewsButton)
        tabContainerView.addSubview(castButton)
        tabContainerView.addSubview(tabUnderlineView)
    }
    
    private func setupConstraints() {

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        backdropImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }

        infoContainerView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(-40)
            make.leading.trailing.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(120)
            make.height.equalTo(180)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
        }

        tabContainerView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        aboutButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        reviewsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        castButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        tabUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(aboutButton.snp.bottom).offset(6)
            make.leading.equalTo(aboutButton)
            make.width.equalTo(aboutButton)
            make.height.equalTo(2)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(tabContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }

    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                
                let movie = self.viewModel.movieDetail
                self.titleLabel.text = movie?.title
                self.overviewLabel.text = movie?.overview
                
                if let backdrop = movie?.backdropPath {
                    self.backdropImageView.loadImage(path: backdrop)
                }
                
                if let poster = movie?.posterPath {
                    self.posterImageView.loadImage(path: poster)
                }
                
                self.updateWatchlistIcon()
            }
        }
    }
}
