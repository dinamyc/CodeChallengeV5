//
//  Networking.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import Foundation

enum Result<T, E> {
    case success(T)
    case failure(E)
}

enum APIError: Error, Equatable {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case let (.networkError(error1), .networkError(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.invalidResponse, .invalidResponse):
            return true
        case let (.decodingError(error1), .decodingError(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}

struct ResponseValidator {
    static func validateResponse(_ response: URLResponse?) -> APIError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .invalidResponse
        }
        
        return nil
    }
}

final class APIService {
    
    static func request<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let responseError = ResponseValidator.validateResponse(response) {
                completion(.failure(responseError))
                return
            }
            
            do {
                let decodedData = try decodeData(T.self, from: data!)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    private static func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
