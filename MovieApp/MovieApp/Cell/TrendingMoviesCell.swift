//
//  TrendingMoviesCell.swift
//  MovieApp
//
//  Created by Amrah on 04.01.26.
//

import UIKit
import SnapKit

class TrendingMoviesCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: TrendingMoviesCell.self)
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with movie: Movie) {
        guard let url = TMDBImage.poster(movie.posterPath) else {
            posterImageView.image = UIImage(named: "placeholder")
            return
        }

        posterImageView.loadImage(from: url)
    }
    
    //MARK: Private methods
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        
        setupSubview()
        setupConstraints()
    }

    private func setupSubview() {
        contentView.addSubview(posterImageView)
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
