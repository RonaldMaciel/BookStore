//
//  BookDetailViewModel.swift
//  BookStore
//
//  Created by Ronald on 30/09/24.
//

import Foundation

protocol BookDetailViewModelDelegate: AnyObject {
    func saveFavorite(_ book: Item)
    func deleteFavorite(_ book: Item)
    func setupBookDetails()
    func isFavoriteBook(_ value: Bool)
    func checkBook(_ bookID: String) -> Bool
}

class BookDetailViewModel {
    
    weak var delegate: BookDetailViewModelDelegate?
    var book: Item?
    var favoriteBooks: [Item] = []
    
    public func saveFavorite(with book: Item) {
        favoriteBooks.append(book)
        print("saved book to favorites: \(favoriteBooks)\n")
        delegate?.saveFavorite(book)
    }
    
    public func removeFavorite(with book: Item) {
        // if let index = favoriteBooks.firstIndex(of: book) { favoriteBooks.remove(at: index) }
        favoriteBooks.removeAll(where: { $0.id == book.id })
        print("removed book from favorites: \(favoriteBooks)")
        delegate?.deleteFavorite(book)
    }
    
    public func checkIfFavorite(with book: Item) {
        if let isFavorite = delegate?.checkBook(book.id) {
            delegate?.isFavoriteBook(isFavorite)
        }
        
    }
}
