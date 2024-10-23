//
//  FavoriteBooksViewModel.swift
//  BookStore
//
//  Created by Ronald on 08/10/24.
//

import Foundation

protocol FavoriteBooksViewModelDelegate: AnyObject {
    func didLoadEvents()
}

public class FavoriteBooksViewModel {
    weak var delegate: FavoriteBooksViewModelDelegate?
    
    var favorites: [Item] = []
    
    public func fetchFavoriteBooks() {
        self.delegate?.didLoadEvents()
    }
    
    
}
