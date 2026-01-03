//
//  TMDBImage.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//

import Foundation

enum TMDBImage {
    static let baseURL = "https://image.tmdb.org/t/p/w500"

    static func poster(_ path: String?) -> URL? {
        guard let path else { return nil }
        return URL(string: baseURL + path)
    }
}
