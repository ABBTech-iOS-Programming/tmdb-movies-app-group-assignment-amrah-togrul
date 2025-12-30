//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Amrah on 30.12.25.
//


import UIKit

final class HomeViewController: UIViewController {
    private var viewModel = HomeViewModel()
    
    //MARK: Views
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public methods
    func config() {
        
    }

    //MARK: Private methods
    private func setupUI() {
        view.backgroundColor = .primary
        setupSubview()
        setupConstraints()
    }

    private func setupConstraints() {
        
    }

    private func setupSubview() {
        
    }
}
