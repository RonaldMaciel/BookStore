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
    func getBook(_ bookID: String) -> Item
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
    
    public func isFavorite(with book: Item) {
        var newBook = delegate?.getBook(book.id)
        
        if newBook != nil {
            delegate?.isFavoriteBook(true)
        } else {
            delegate?.isFavoriteBook(false)
        }
       // if favoriteBooks.contains(where: { $0.id == book.id }) {
       //     delegate?.isFavoriteBook(true)
       // } else {
       //     delegate?.isFavoriteBook(false)
       // }
    }
}

extension UserDefaults {
    func setFavorite(_ book: Item) {
        if let encodedBook = try? JSONEncoder().encode(book) {
            print("save userDefaults encoded book: \(encodedBook)")
            UserDefaults.standard.set(encodedBook, forKey: book.id)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getFavorite(_ bookID: String) -> Item {
        var newBookID = ""
        
        if let data = UserDefaults.standard.object(forKey: bookID) as? Data,
           let decodedBook = try? JSONDecoder().decode(Item.self, from: data) {
            print("decodedBook >> \(decodedBook)")
            newBookID = decodedBook.id
        }
        
        return UserDefaults.standard.object(forKey: newBookID) as! Item
    }
    
    func removeFavorite(_ book: Item) {
        if let data = UserDefaults.standard.object(forKey: book.id) as? Data,
           let decodedBook = try? JSONDecoder().decode(Item.self, from: data) {
            print("removed userDefaults decoded book: \(decodedBook)")
            UserDefaults.standard.removeObject(forKey: decodedBook.id)
            UserDefaults.standard.synchronize()
        }
        
    }
}
