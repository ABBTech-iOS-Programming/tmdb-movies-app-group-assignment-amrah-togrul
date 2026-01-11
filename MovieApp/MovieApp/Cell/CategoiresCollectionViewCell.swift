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
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .app(.poppinsRegular(size: 14))
        label.textColor = .white
        return label
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.isHidden = true
        return view
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
        setupStyle()
    }
    
    private func setupStyle() {
        contentView.backgroundColor = .clear
    }

    private func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(12)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    private func setupSubview() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(bottomBorder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = nil
        bottomBorder.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            bottomBorder.isHidden = !isSelected
        }
    }
}
