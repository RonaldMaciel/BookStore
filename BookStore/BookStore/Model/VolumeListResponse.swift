//
//  VolumeListResponse.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import Foundation

public struct VolumeListResponse {
    var totalItems: String
    var books: [VolumeModel]?
}
