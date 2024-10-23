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
    
    func fetchBooks(completion: @escaping (_ apiData: BookListResponse) -> Void) {
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
    
   //public func getBookWith(name: String, completionHandler: @escaping (Any?) -> Void) {
   //    guard let specificsString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else  {
   //        completionHandler(nil)
   //        return
   //    }
        
        
       //AF.request(BooksEndpoint.books(specificsString)).response { (response: AFDataResponse<BookListResponse>) in
       //
       //    switch response.result {
       //    case .success(let data):
       //        do {
       //            print("JSON DATA:\n \(data)\n")
       //            completionHandler(data)
       //        } catch {
       //            print(error.localizedDescription)
       //        }
       //    case .failure(let error):
       //        print("Error: \(error.localizedDescription)")
       //    }
       //
       //
       //}
    // }
}


