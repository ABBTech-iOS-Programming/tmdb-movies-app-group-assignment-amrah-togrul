//
//  WatchListViewController.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


import UIKit
import SnapKit

final class WatchListViewController: UIViewController {
    
    private var viewModel = WatchListViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let inset: CGFloat = 20
        let width = (UIScreen.main.bounds.width - inset * 2 - spacing) / 2
        let height = width * 1.5
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 20, left: inset, bottom: 20, right: inset)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .primary
        cv.delegate = self
        cv.dataSource = self
        cv.register(WatchListMovieCell.self,
                    forCellWithReuseIdentifier: WatchListMovieCell.reuseIdentifier)
        
        return cv
    }()
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    init(viewModel: WatchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadWatchlist()
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func config() {
        
    }
    
    private func setupUI() {
        view.backgroundColor = .primary
        title = "Watch list"
        setupSubview()
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview() }
    }
    
    private func setupSubview() {
        view.addSubview(collectionView)
    }
}


extension WatchListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WatchListMovieCell.reuseIdentifier,
            for: indexPath
        ) as! WatchListMovieCell

        let movie = viewModel.movie(at: indexPath.row)
        cell.configure(with: movie)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let movie = viewModel.movie(at: indexPath.row)
        let vc = MovieDetailViewController(movieId: movie.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
