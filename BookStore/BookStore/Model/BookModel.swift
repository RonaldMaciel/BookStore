//
//  BookModel.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import Foundation
import Alamofire

struct BookModel: Codable {
    
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    
    struct ImageLinks: Codable {
        let smallThumbnail: String?
        let thumbnail: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case subtitle = "subtitle"
        case authors = "authors"
        case description = "description"
        case imageLinks = "imageLinks"
    }
}
