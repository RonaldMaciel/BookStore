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
    func showFavoriteBooks(_ books: [Item])
    
}

public class BooksViewModel {
    weak var delegate: BooksViewModelDelegate?
    
    var apiClient = APIClient()
    var allBooks: [Item] = []
    var shouldDisplaySearch: Bool = false
    var bookName: String?
    var filter: String?
    var favorites: [Item] = []
    
    var currentPage = 1
    var isLoading = false
    
    public func fetchBooks() {
        
        guard !isLoading else { return }
        isLoading = true
        
        apiClient.fetchBooks { apiData in
            DispatchQueue.main.async {
                self.isLoading = false
                if apiData.totalItems == 0 {
                    self.delegate?.showErrorAlert(title: "Error!",
                                                  message: "Wasn't possible to load the books.")
                } else {
                    self.allBooks.append(contentsOf: apiData.items)
                    self.currentPage += 1
                }
                
                self.delegate?.didLoadEvents()
            }
        }
    }
    
    public func fetchMoreBooks() {

        guard !isLoading else { return }
        isLoading = true
        
        apiClient.fetchMoreBooks(pagination: true, with: currentPage) { apiData in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if apiData.totalItems == 0 {
                    self.delegate?.showErrorAlert(title: "Error!",
                                                  message: "Wasn't possible to load the books.")
                } else {
                    self.allBooks.append(contentsOf: apiData.items)
                    self.currentPage += 1
                }
            }
        }
        
        self.delegate?.didLoadEvents()
    }
    
    public func didSelectBook(at index: Int) {
        let book = allBooks[index]
        delegate?.showBookDetails(book)
    }
    
    public func didSelectFavorite() {
        delegate?.showFavoriteBooks(favorites)
    }
        
    public func applySearch(withFilter filter: String) {
        self.filter = filter
        shouldDisplaySearch = true
        delegate?.didLoadEvents()
    }
    
    public func cancelSearch() {
        filter = nil
        shouldDisplaySearch = false
        delegate?.didLoadEvents()
    }
    
    
}
