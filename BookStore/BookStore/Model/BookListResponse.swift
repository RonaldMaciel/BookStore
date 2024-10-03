//
//  BookListResponse.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import Foundation

struct BookListResponse: Codable {
    let totalItems: Int
    let items: [Item]
}

struct Item: Codable {
    let volumeInfo: BookModel
    let saleInfo: SaleInfo
    
    enum CodingKeys: String, CodingKey {
        case volumeInfo = "volumeInfo"
        case saleInfo = "saleInfo"
    }
}

struct SaleInfo: Codable {
    let country: Country
    let listPrice: SaleInfoListPrice?
    let buyLink: String?
    
    enum CodingKeys: String, CodingKey{
        case country = "country"
        case listPrice = "listPrice"
        case buyLink = "buyLink"
    }
}

struct SaleInfoListPrice: Codable {
    let amount: Double
    let currencyCode: CurrencyCode
}

enum Country: String, Codable {
    case br = "BR"
    case pt = "PT"
}

enum CurrencyCode: String, Codable {
    case brl = "BRL"
    case eur = "EUR"
}
