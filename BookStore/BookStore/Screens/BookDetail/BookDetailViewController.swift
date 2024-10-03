//
//  BookDetailViewController.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit


class BookDetailViewController: UIViewController {
    
    // MARK: - Attributes
    let viewModel = BookDetailViewModel()
    
    // MARK: - Attributes
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var buyBookButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        configureBookDetails(with: viewModel.book!)
    }
        
    
    // MARK: - Configuration
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
}

// MARK: - EventDetailViewModelDelegate
extension BookDetailViewController: BookDetailViewModelDelegate {
    func configureBookDetails(with book: Item) {
        titleLabel.text = book.volumeInfo.title
        subtitleLabel.text = book.volumeInfo.subtitle
        
        let authorsStringFormatted = book.volumeInfo.authors?.joined(separator: ", ")
        authorLabel.text = authorsStringFormatted
        
        guard let bookPrice = book.saleInfo.listPrice?.amount else {
            return
        }
        
        priceLabel.text = "$\(bookPrice)"
        
        
       // priceLabel.text = "\(book.saleInfo.listPrice?.amount ??
        descriptionLabel.text = book.volumeInfo.description

        guard let bookImageString = book.volumeInfo.imageLinks?.thumbnail else { return }
        let url = URL(string: bookImageString)
        bookImageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: nil,
                                  progressBlock: nil,
                                  completionHandler: { result in
            switch result {
            case .success(let data):
                print("Book Image: \(data.image.debugDescription), from: \(data.cacheType)")
                
            case .failure(let error):
                print("Book Image Error: \(error)")
            }
        })
        
        if book.saleInfo.buyLink == nil {
            buyBookButton.isHidden = true
        }
        
    }

}
