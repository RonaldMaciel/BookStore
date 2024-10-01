//
//  BookDetailViewModel.swift
//  BookStore
//
//  Created by Ronald on 30/09/24.
//

protocol BookDetailViewModelDelegate: AnyObject {
    func configureBookDetails(with book: Item)
}

class BookDetailViewModel {
    
    weak var delegate: BookDetailViewModelDelegate?
    var book: Item?
    
}
