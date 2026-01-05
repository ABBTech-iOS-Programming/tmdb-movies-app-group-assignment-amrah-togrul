//
//  CategoiresCollectionViewCell.swift
//  MovieApp
//
//  Created by Amrah on 05.01.26.
//

import UIKit
import SnapKit

final class CategoiresCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CategoiresCollectionViewCell.self)
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public methods
    func config(with category: MovieCategory) {
        categoryLabel.text = category.title
    }
    
    //MARK: Private methods
    private func setupUI() {
        setupSubview()
        setupConstraints()
    }

    private func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    private func setupSubview() {
        contentView.addSubview(categoryLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = nil
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemBlue : .white
            categoryLabel.textColor = isSelected ? .white : .black
        }
    }
}
