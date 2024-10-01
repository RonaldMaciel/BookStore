//
//  BooksViewModel.swift
//  BookStore
//
//  Created by Ronald on 29/09/24.
//

import Foundation
import Alamofire

protocol BooksViewModelDelegate: AnyObject {
    func didLoadEvents()
    func showErrorAlert(title: String, message: String)
    func showBookDetails(_ book: Item)
}

public class BooksViewModel {
    weak var delegate: BooksViewModelDelegate?
    
    var apiClient = APIClient()
    var allBooks: [Item] = []
    var allBooksImagesURLString: [String] = []
    
    public func fetchBooks() {
        apiClient.fetchBooks { apiData in
            if apiData.totalItems == 0 {
                self.delegate?.showErrorAlert(title: "Error!",
                                              message: "Wasn't possible to load the books.")
            } else {
                self.allBooks = apiData.items
                
                for book in self.allBooks {
                    if let bookImageURLString = book.volumeInfo.imageLinks?.smallThumbnail {
                        if !(bookImageURLString.isEmpty) {
                            self.allBooksImagesURLString.append(bookImageURLString)
                        }
                    }
                }
            }
            
            self.delegate?.didLoadEvents()
        }
    }
    
    public func didSelectBook(at index: Int) {
        let book = allBooks[index]
        delegate?.showBookDetails(book)
    }
}
