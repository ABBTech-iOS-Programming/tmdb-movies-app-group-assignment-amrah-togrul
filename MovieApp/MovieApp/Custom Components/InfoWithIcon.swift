//
//  InfoWithIcon.swift
//  MovieApp
//
//  Created by Amrah on 07.01.26.
//

import UIKit
import SnapKit

final class InfoWithIcon: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(icon: String, title: String, isRating: Bool = false) {
        super.init(frame: .zero)
        iconView.image = UIImage(systemName: icon)
        titleLabel.text = title
        
        if isRating {
            iconView.tintColor = .attention
            titleLabel.font = .app(.montserratSemiBold(size: 12))
            titleLabel.textColor = .attention
        } else {
            iconView.tintColor = .white
            titleLabel.font = .app(.poppinsRegular(size: 12))
            titleLabel.textColor = .white
        }
        
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Public method to update text
    func update(text: String) {
        titleLabel.text = text
    }
    
    //MARK: Private methods
    private func setupSubview() {
        addSubview(stackView)
        [iconView, titleLabel].forEach(stackView.addArrangedSubview)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
    }
}
