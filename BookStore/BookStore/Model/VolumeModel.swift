//
//  VolumeModel.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import Foundation

struct VolumeModel {
    var title: String?
    var subtitle: String?
    var authors: [String]?
    var textSnippet: String?
    var description: String?
    var smallThumbnail: String?
    var thumbnail: String?
    
    init(title: String?,
         subtitle: String?,
         authors: [String]?,
         textSnippet: String?,
         description: String?,
         averageRating: Double?,
         smallThumbnail: String?,
         thumbnail: String?) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.textSnippet = textSnippet
        self.description = description
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
    }
}
