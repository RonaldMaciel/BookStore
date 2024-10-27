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
    private var baseURL = BooksEndpoint.Constants.baseURLPath
    
    var isPaginating = false
    
    func fetchBooks(completion: @escaping (_ apiData: BookListResponse) -> Void) {
        let url = baseURL+"?q=ios"
        
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
                    
                    DispatchQueue.main.async {
                        completion(jsonData)
                    }
                    
                    print("JSON DATA:\n \(jsonData)\n")
                    
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("JSON Error: \(error.localizedDescription)")
            }}
    }
    
    mutating func fetchMoreBooks(pagination: Bool = false, with page: Int, completion: @escaping (_ apiData: BookListResponse) -> Void) {
        
        let url = baseURL+"?q=ios+startIndex=\(page)"
        print("page in api: \(page)")
        
        if pagination {
            self.isPaginating = true
        }
        
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
                    DispatchQueue.main.async {
                        completion(jsonData)
                        print("JSON DATA MORE BOOKS:\n \(jsonData)\n")
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print("JSON Error: \(error.localizedDescription)")
            }
        }
        
        if pagination {
            self.isPaginating = false
        }
    }
    
    // public func getBookWith(name: String, completionHandler: @escaping (Any?) -> Void) {
    //    guard let specificsString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else  {
    //        completionHandler(nil)
    //        return
    //    }
    //
    //
    //    AF.request("https://www.googleapis.com/books/v1/volumes?q=())",
    //               method: .get,
    //               parameters: "nil",
    //               encoding: URLEncoding.default,
    //               headers: nil,
    //               interceptor: nil)
    //
    //    AF.request(BooksEndpoint.volumes(specificsString)).response { (response: AFDataResponse<BookListResponse>) in
    //
    //        switch response.result {
    //        case .success(let data):
    //            do {
    //                print("JSON DATA:\n \(data)\n")
    //                DispatchQueue.main.async {
    //                    completion(jsonData)
    //                }
    //            } catch {
    //                print(error.localizedDescription)
    //            }
    //        case .failure(let error):
    //            print("Error: \(error.localizedDescription)")
    //        }
    //
    //
    //    }
    //  }
    
    
    
}
