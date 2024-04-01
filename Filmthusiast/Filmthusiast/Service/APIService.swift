//
//  APIService.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import ObjectMapper

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
            "Authorization": "Bearer \(APIConstant.ACCESS_TOKEN)"
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
