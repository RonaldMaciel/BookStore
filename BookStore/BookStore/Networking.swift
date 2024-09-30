//
//  Networking.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import Alamofire
import Foundation

public struct APIClient {
    // MARK: - Singleton
    public static let shared = APIClient()
    
    public func fetchBooks(completion: @escaping (_ apiData: BookListResponse) -> Void) {
        let url = "https://www.googleapis.com/books/v1/volumes?q=*"
        
        AF.request(url, method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil)
        .response { response  in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(BookListResponse.self, from: data!)
                    print("JSON DATA:\n \(jsonData)\n")
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }}
    }
    
    func fetchBookImage(with book: BookModel) {
            
    }
    
}
