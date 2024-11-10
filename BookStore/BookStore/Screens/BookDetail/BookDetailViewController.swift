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
    private let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBookDetails()
        configureBookDetails()
    }
    
    
    // MARK: - Configuration
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if !isFavorite {
            isFavorite = true
            favoriteButton.tintColor = .orange
            viewModel.saveFavorite(with: viewModel.book!)

        } else {
            isFavorite = false
            favoriteButton.tintColor = .black
            viewModel.removeFavorite(with: viewModel.book!)
        }
    }
    
    internal func configureBookDetails() {
        viewModel.checkIfFavorite(with: viewModel.book!)
    }
}

// MARK: - EventDetailViewModelDelegate
extension BookDetailViewController: BookDetailViewModelDelegate {
    
    func saveFavorite(_ book: Item) {
        userDefaults.setFavorite(book)
    }
    
    func deleteFavorite(_ book: Item) {
        userDefaults.removeFavorite(book)
    }
    
    func isFavoriteBook(_ value: Bool) {
        if value {
            isFavorite = true
            favoriteButton.tintColor = .orange
        } else {
            isFavorite = false
            favoriteButton.tintColor = .black
        }
    }
    
    func checkBook(_ bookID: String) -> Bool {
        return userDefaults.checkFavorite(bookID)
    }
    
    func setupBookDetails() {
        if let title = viewModel.book?.volumeInfo.title {
            titleLabel.text = title
        }
        
        if viewModel.book?.volumeInfo.subtitle != nil {
            subtitleLabel.text = viewModel.book?.volumeInfo.subtitle
        } else { subtitleLabel.text = "" }
        
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


protocol CacheProtocol {
    associatedtype Input = AnyObject
    associatedtype Output = Decodable
    
    func insertCache(object: Input, forKey key: String) throws
    func getCached(forKey key: String) throws -> Output
    func deleteFromCache(forKey key: String)
}

final class WorkerCacheManager: CacheProtocol {
    
    typealias Input = StructWrapper
    typealias Output = Decodable
    
    let cache = NSCache<Worker.UnwrappedKey, StructWrapper<Worker>>()
    
    enum Error: Swift.Error {
        case typeCasting
        case cantGetFromCache
    }
    
    func insertCache<Input>(object: Input, forKey key: String) throws {
        guard let object = object as? Worker else {
            throw Error.typeCasting
        }
        let wrapper: StructWrapper<Worker> = StructWrapper(value: object)
        cache.setObject(wrapper, forKey: wrapper.value.id)
    }
    
    func getCached<Output>(forKey key: String) throws -> Output {
        let key: Worker.UnwrappedKey = Worker.UnwrappedKey(key: key)
        guard let wrapper = cache.object(forKey: key) as? StructWrapper else {
            throw Error.typeCasting
        }
        guard let worker = wrapper.value as? Output else { throw Error.typeCasting }
        return worker
    }
    
    func deleteFromCache(forKey key: String) {
        let key: Worker.UnwrappedKey = Worker.UnwrappedKey(key: key)
        cache.removeObject(forKey: key)
    }
}


final class StructWrapper<Element: Decodable>: NSObject {
    let value: Element
    
    init(value: Element) {
        self.value = value
    }
}

struct Worker: Decodable {
    
    var id: UnwrappedKey
    
    init(from decoder: Decoder) throws {
        // In here, it will decode all defined variables
        self.id = UnwrappedKey(key: "")
    }
    
    init(id: String) {
        self.id = UnwrappedKey(key: id)
    }
    
    class UnwrappedKey: NSObject {
        var key: String
        
        init(key: String) {
            self.key = key
        }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? UnwrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}
