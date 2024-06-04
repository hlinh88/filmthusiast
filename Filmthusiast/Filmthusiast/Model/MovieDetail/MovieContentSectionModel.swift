//
//  MovieContentSectionModel.swift
//  Filmthusiast
//
//  Created by Luke Nguyen on 4/6/24.
//

import Foundation

struct MovieContentSectionModel {
    let id: Int
    let image: String
    let title: String
    let desc: String
    
    init(id: Int, image: String, title: String, desc: String) {
        self.id = id
        self.image = image
        self.title = title
        self.desc = desc
    }
}
