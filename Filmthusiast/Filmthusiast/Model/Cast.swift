//
//  Cast.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 7/4/2024.
//

import Foundation
import ObjectMapper

struct CastList: ImmutableMappable {
    var casts: [Cast]
    var crew: [Crew]

    init(map: Map) throws {
        casts = try map.value("cast")
        crew = try map.value("crew")
    }
}

struct Cast: ImmutableMappable {
    var id: Int
    var name: String
    var profilePath: String
    var character: String

    init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        if let profileEndpoint: String = try map.value("profile_path") {
            profilePath = Constant.IMAGE_BASE_URL + profileEndpoint
        } else {
            profilePath = ""
        }
        character = try map.value("character")
    }
}

struct Crew: ImmutableMappable {
    var id: Int
    var name: String
    var profilePath: String
    var job: String?

    init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        if let profileEndpoint: String = try map.value("profile_path") {
            profilePath = Constant.IMAGE_BASE_URL + profileEndpoint
        } else {
            profilePath = ""
        }
        job = try? map.value("job")
    }
}

