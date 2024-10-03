//
//  BookEndpoint.swift
//  BookStore
//
//  Created by Ronald on 03/10/24.
//

import Foundation
import Alamofire

enum BooksEndpoint: URLConvertible {
    
    enum Constants {
        static let baseURLPath = "https://www.googleapis.com/books/v1"
    }
    
    case books(String)

    var method: HTTPMethod {
        switch self {
        case .books:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .books:
            return "/volumes"
        }
    }
    
    var param: [String: Any] {
        switch self {
        case .books(let query):
            return [ "q" : query]
        }
    }
    
    func asURL() throws -> URL {
        let baseUrl = try Constants.baseURLPath.asURL()
        let url = baseUrl.appendingPathComponent(path)
        
        return url
        
        // var request = URLRequest(url: url)
        // request.httpMethod = method.rawValue
        // return try URLEncoding.default.encode(request, with: param)
    }
}
