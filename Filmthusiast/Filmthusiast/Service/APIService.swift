//
//  APIService.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import ObjectMapper

enum APIEndpoint {
    enum MOVIE_LISTS {
        static let CATEGORY = "https://api.themoviedb.org/3/movie/%@?language=en-US&page=1"
    }

    enum MOVIE_DETAIL {
        static let DETAILS = "https://api.themoviedb.org/3/movie/%@"
        static let IMAGES = "https://api.themoviedb.org/3/movie/%@/images"
        static let CASTS = "https://api.themoviedb.org/3/movie/%@/credits"
    }
}

class APIService {

    static let shared = APIService()

    func callAPI<T: ImmutableMappable>(urlString: String, method: HTTPMethod = .get, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZjc5NmUyMDE0M2E3MzU2NTEzZGY1ZjAyOWJlYTJhOSIsInN1YiI6IjY1ZjgyMDE3ZTIxMDIzMDE3ZWVmZWIxNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FJsf7kR_IZax0Y80iwbZlZDFxNzoWa18i_b2uHikQxA"
        ]

        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let decodedData =  Mapper<T>().map(JSONObject: jsonObject) else {
                    completion(.failure(.invalidData))
                    return
                }
                print("""
                    ==API Response: 💖💖💖
                    \(decodedData)
                    """)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }

        task.resume()
    }


}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidData
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
