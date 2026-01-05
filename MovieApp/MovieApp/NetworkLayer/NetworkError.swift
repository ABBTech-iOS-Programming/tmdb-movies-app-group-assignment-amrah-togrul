//
//  NetworkError.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(statusCode: Int)
    case unknown(Error)
}
