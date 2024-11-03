//
//  FavoriteBooksViewModel.swift
//  BookStore
//
//  Created by Ronald on 08/10/24.
//

import Foundation

protocol FavoriteBooksViewModelDelegate: AnyObject {
    func getFavoriteBookName(with bookID: String) -> String
    func didLoadEvents()
}

public class FavoriteBooksViewModel {
    weak var delegate: FavoriteBooksViewModelDelegate?
    
    var favoriteBooksNames: [String] = []
    
    public func fetchFavoriteBooks() {
        //print("all keys: \(UserDefaults.standard.dictionaryRepresentation().keys) ")
        let favoriteBooksKeysValues = UserDefaults.standard.dictionaryRepresentation().keys.filter({ $0.contains("favoriteBook") })

        favoriteBooksKeysValues.forEach { bookID in
            if let bookname = delegate?.getFavoriteBookName(with: bookID) {
                print("got book: \(bookname)")
                self.favoriteBooksNames.append(bookname)
            }
        }
        delegate?.didLoadEvents()
    }
}


