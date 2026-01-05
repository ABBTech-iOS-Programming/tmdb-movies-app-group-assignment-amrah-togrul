//
//  TMDBAuthProvider.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//


final class TMDBAuthProvider: AuthProviding {

    private let token: String

    init(token: String) {
        self.token = token
    }

    var authHeader: String? {
        "Bearer \(token)"
    }
}
