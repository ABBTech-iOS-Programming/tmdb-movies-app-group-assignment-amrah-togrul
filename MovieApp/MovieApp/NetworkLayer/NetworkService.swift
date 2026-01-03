//
//  NetworkService.swift
//  MovieApp
//
//  Created by Amrah on 03.01.26.
//
import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endPoint: Endpoint, completion: @escaping
        (Result<T, NetworkError>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    private let session: URLSession
    private let authProvider: AuthProviding?

    func request<T: Decodable>(_ endPoint: Endpoint, completion: @escaping
        (Result<T, NetworkError>) -> Void)
    {
        let createRequest = endPoint.makeRequest()
        switch createRequest {
        case .success(var request):
            if let authHeader = authProvider?.authHeader {
                request.setValue(authHeader, forHTTPHeaderField: "Authorization")
            }
            
            session.dataTask(with: request) { data, response, error in
                if let error {
                    completion(.failure(.unknown(error)))
                }
                if let HTTPResponse = response as? HTTPURLResponse{
                    let statusCode = HTTPResponse.statusCode
                    guard (200...299).contains(statusCode) else {
                        return completion(.failure(.serverError(statusCode: statusCode)))
                    }
                }
                guard let data else {
                    return completion(.failure(.noData))
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
                
            }.resume()

        case .failure(let error):
            completion(.failure(error))
        }
    }

    init(
        session: URLSession = .shared,
        authProvider: AuthProviding? = TMDBAuthProvider(
            token: AppConfig.tmdbBearerToken
        )
    ) {
        self.session = session
        self.authProvider = authProvider
    }

}
