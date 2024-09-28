//
//  VolumeModel.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import Foundation

public struct VolumeModel {
    public var title: String?
    public var subtitle: String?
    public var authors: [String]?
    public var description: String?
    public var price: String?
    public var thumbnail: String?
    public var buyLink: URL?
    
    init(title: String?,
         subtitle: String?,
         authors: [String]?,
         description: String?,
         averageRating: Double?,
         price: String?,
         thumbnail: String?,
         buyLink: URL?
    ){
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.description = description
        self.price = price
        self.thumbnail = thumbnail
        self.buyLink = buyLink
    }
}
