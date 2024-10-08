//
//  BookDetailViewController.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit
import Kingfisher

class BookDetailViewController: UIViewController {
    
    // MARK: - Attributes
    let viewModel = BookDetailViewModel()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var buyBookButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var buyLinkString: String?
    private var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        configureBookDetails()
    }
        
    
    // MARK: - Configuration
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if isFavorite {
            favoriteButton.tintColor = .black
            isFavorite = false
            
        } else {
            favoriteButton.tintColor = .orange
            isFavorite = true
        }
    }
    
}

// MARK: - EventDetailViewModelDelegate
extension BookDetailViewController: BookDetailViewModelDelegate {
    func configureBookDetails() {
        if let title = viewModel.book?.volumeInfo.title {
            titleLabel.text = title
        }
        
        if let subtitle = viewModel.book?.volumeInfo.subtitle {
            subtitleLabel.text = subtitle
        }
        
        if let authors = viewModel.book?.volumeInfo.authors {
            let authorsStringFormatted = authors.joined(separator: ", ")
            authorLabel.text = authorsStringFormatted
        }
        
        
        if let bookPrice = viewModel.book?.saleInfo.listPrice?.amount {
            priceLabel.text = "$\(String(describing: bookPrice))"
        } else {
            priceLabel.isHidden = true
        }
        
        if let description = viewModel.book?.volumeInfo.description {
            descriptionLabel.text = description
        }

        if let bookImageString = viewModel.book?.volumeInfo.imageLinks?.thumbnail {
            let url = URL(string: bookImageString)
            bookImageView.kf.setImage(with: url)
        }
        
        if viewModel.book?.saleInfo.buyLink == nil {
            buyBookButton.setTitle("Not for sale", for: .normal)
        }
        
    }
    
    @IBAction private func buyButtonTapped(_ sender: UIButton) {

        guard let buyLinkStringToURL = viewModel.book?.saleInfo.buyLink else { return }
        if let url = URL(string: buyLinkStringToURL) {
            print("Buy link: \(buyLinkStringToURL)")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
