//
//  Review.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//


struct Review: Decodable {
    let id: String
    let author: String
    let content: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
        case createdAt = "created_at"
    }
}