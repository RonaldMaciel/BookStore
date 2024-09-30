//
//  BooksViewModel.swift
//  BookStore
//
//  Created by Ronald on 29/09/24.
//

import Foundation

protocol BooksViewModelDelegate: AnyObject {
    func didLoadEvents()
    func showErrorAlert(title: String, message: String)
}

public class BooksViewModel {
    weak var delegate: BooksViewModelDelegate?
    
    public var apiClient = APIClient()
    public var allBooks: [BookListResponse] = []
    
    public func fetchBooks() {
        // api call
    }
    
}
