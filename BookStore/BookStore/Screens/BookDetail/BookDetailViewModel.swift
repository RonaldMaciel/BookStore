//
//  BookDetailViewModel.swift
//  BookStore
//
//  Created by Ronald on 30/09/24.
//

protocol BookDetailViewModelDelegate: AnyObject {
    func configureBookDetails()
}

class BookDetailViewModel {
    
    weak var delegate: BookDetailViewModelDelegate?
    var book: Item?
    var favoriteBooks: [Item] = []
}
