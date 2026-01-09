//
//  SearchedMoviesCollectionViewCell.swift
//  MovieApp
//
//  Created by Amrah on 07.01.26.
//

import UIKit
import SnapKit

final class SearchedMoviesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SearchedMoviesCollectionViewCell.self)
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .secondary
        return imageView
    }()
    
    private let generalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let generalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private let detailsInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .app(.poppinsSemiBold(size: 16))
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingView: InfoWithIcon = {
        return InfoWithIcon(icon: "star.fill", title: "0.0", isRating: true)
    }()
    
    private lazy var yearView: InfoWithIcon = {
        return InfoWithIcon(icon: "calendar", title: "2024")
    }()
    
    private lazy var durationView: InfoWithIcon = {
        return InfoWithIcon(icon: "clock", title: "N/A")
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with movie: Movie) {
        titleLabel.text = movie.title
        
        ratingView.update(text: String(format: "%.1f", movie.voteAverage))
        
        if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
            let year = String(releaseDate.prefix(4))
            yearView.update(text: year)
        } else {
            yearView.update(text: "N/A")
        }
        
        durationView.update(text: "N/A")
        
        if let posterPath = movie.posterPath, let url = TMDBImage.poster(posterPath) {
            posterImageView.loadImage(from: url)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
    
    //MARK: Private methods
    private func setupUI() {
        contentView.backgroundColor = .secondary
        contentView.layer.cornerRadius = 16
        setupSubview()
        setupConstraints()
    }

    private func setupSubview() {
        contentView.addSubview(generalStackView)
        [posterImageView, generalInfoStackView].forEach(generalStackView.addArrangedSubview)
        [titleLabel, detailsInfoStackView].forEach(generalInfoStackView.addArrangedSubview)
        [ratingView, yearView, durationView].forEach(detailsInfoStackView.addArrangedSubview)
    }

    private func setupConstraints() {
        generalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(95)
            make.height.equalTo(120)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
    }
}
