//
//  UserDefaults+Extension.swift
//  BookStore
//
//  Created by Ronald on 02/11/24.
//

import Foundation

extension UserDefaults {
    func setFavorite(_ book: Item) {
        if let encodedBook = try? JSONEncoder().encode(book) {
            print("save userDefaults encoded book: \(encodedBook)")
            UserDefaults.standard.set(encodedBook, forKey: "favoriteBook:\(book.id)")
            UserDefaults.standard.synchronize()
        }
    }
    
    func checkFavorite(_ bookID: String) -> Bool {
        var isFavorite = false
        
        if let data = UserDefaults.standard.object(forKey: "favoriteBook:\(bookID)") as? Data,
           let decodedBook = try? JSONDecoder().decode(Item.self, from: data) {
            print("decodedBook >> \(decodedBook)")
            isFavorite = true
        }
        
        return isFavorite
    }
    
    func removeFavorite(_ book: Item) {
        if let data = UserDefaults.standard.object(forKey: "favoriteBook:\(book.id)") as? Data,
           let decodedBook = try? JSONDecoder().decode(Item.self, from: data) {
            print("removed userDefaults decoded book: \(decodedBook)")
            UserDefaults.standard.removeObject(forKey: "favoriteBook:\(decodedBook.id)")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getFavorite(_ bookID: String) -> String { // Item?
        var bookName = ""
        
        if let data = UserDefaults.standard.object(forKey: "favoriteBook:\(bookID)") as? Data,
           let decodedBook = try? JSONDecoder().decode(Item.self, from: data) {
            bookName = decodedBook.volumeInfo.title!
        }
        
        return bookName
    }
    
}
