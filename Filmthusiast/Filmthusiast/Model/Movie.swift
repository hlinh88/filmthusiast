//
//  Movie.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import Foundation


struct Response: Codable {
    var data: [Movie]
}

struct Movie: Codable {
    var id: Int
    var backdrop: String
    var title: String
    var overview: String
    var poster: String
    var releaseDate: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case releaseDate = "release_date"
        case title, overview, id, status
    }
}

struct MovieList: Codable {
    var results: [Movie]
    var page: Int

    enum CodingKeys: String, CodingKey {
        case results, page
    }
}
