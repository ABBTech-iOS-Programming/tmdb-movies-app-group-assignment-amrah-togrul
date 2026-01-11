//
//  ImageLoader.swift
//  MovieApp
//
//  Created by Toğrul Niyazlı on 11.01.26.
//

import UIKit

extension UIImageView {

    func loadImage(path: String?) {
        guard let path else { return }

        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
