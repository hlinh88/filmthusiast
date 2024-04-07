//
//  Movie.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import Foundation
import ObjectMapper

struct Movie: ImmutableMappable {
    var id: Int
    var backdrop: String
    var title: String
    var overview: String
    var poster: String
    var releaseDate: String?
    var status: String?
    var genres: [Genre]?

    init() {
        self.id = 0
        self.backdrop = ""
        self.title = ""
        self.overview = ""
        self.poster = ""
        self.releaseDate = nil
        self.status = nil
        self.genres = []
    }

    init(map: ObjectMapper.Map) throws {
        id = try map.value("id")
        if let backdropEndpoint: String = try map.value("backdrop_path") {
            backdrop = Constant.IMAGE_ORIGINAL_BASE_URL + backdropEndpoint
        } else {
            backdrop = ""
        }
        title = try map.value("title")
        overview = try map.value("overview")
        if let posterEndpoint: String = try map.value("poster_path") {
            poster = Constant.IMAGE_BASE_URL + posterEndpoint
        } else {
            poster = ""
        }
        releaseDate = try? map.value("release_date")
        status = try? map.value("status")
        genres = try? map.value("genres")
    }
}

struct Genre: ImmutableMappable {
    var id: String
    var name: String
    
    init(map: Map) throws {
        id = UUID().uuidString
        name = try map.value("name")
    }
}

struct Backdrop: ImmutableMappable {
    var filePath: String

    init(map: Map) throws {
        if let filePathEndpoint: String = try map.value("file_path") {
            filePath = Constant.IMAGE_ORIGINAL_BASE_URL + filePathEndpoint
        } else {
            filePath = ""
        }
    }
}

struct BackdropList: ImmutableMappable {
    var backdrops: [Backdrop]

    init(map: ObjectMapper.Map) throws {
        backdrops = try map.value("backdrops")
    }
}

struct MovieList: ImmutableMappable {
    var results: [Movie]
    var page: Int

    init(map: ObjectMapper.Map) throws {
        results = try map.value("results")
        page = try map.value("page")
    }
}

