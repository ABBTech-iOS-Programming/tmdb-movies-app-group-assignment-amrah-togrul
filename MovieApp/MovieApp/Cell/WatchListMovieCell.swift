//
//  WatchListMovieCell.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

import UIKit
import SnapKit

final class WatchListMovieCell: UICollectionViewCell {

    static let reuseIdentifier = "WatchListMovieCell"


    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.4)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().offset(6)
        }
    }


    func configure(with movie: Movie) {
        titleLabel.text = movie.title

        if let posterPath = movie.posterPath {
            posterImageView.loadImage(path: posterPath)
        }
    }
}
