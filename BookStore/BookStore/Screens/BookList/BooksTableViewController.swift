//
//  ViewController.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit
import Kingfisher

final class BooksTableViewController: UITableViewController {
    
    // MARK: - Attributes
    private let viewModel = BooksViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBarFavoriteButton()
        setupSearchBar()
        setUpRefreshControl()
        setupViewModel()
    }
    
    // MARK: - Setup & Configuration
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.rowHeight = 200
        tableView?.estimatedRowHeight = 200
    }
    
    
    private func setupNavigationBarFavoriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                            target: self,
                                                            action: #selector(didTapFavoriteButton))
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = UISearchController.defaultSearchController(searchBarDelegate: self,
                                                                                     textFieldDelegate: self)
    }
    
    
    @objc private func didTapFavoriteButton() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        print("\(viewModel.favorites)")
    }
    
    private func setUpRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        
    }
    

    @objc private func handleRefresh() {
        viewModel.fetchBooks()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchBooks()
    }
}

// MARK: - UITableViewDataSource
extension BooksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(self.viewModel.allBooks.count)")
        return self.viewModel.allBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as? BookCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        let book = viewModel.allBooks[indexPath.row]
        
        let bookImageString = viewModel.allBooksImagesURLString[indexPath.row]
        let url = URL(string: bookImageString)
        cell.thumbnailImageView.kf.setImage(with: url,
                                            placeholder: nil,
                                            options: nil,
                                            progressBlock: nil,
                                            completionHandler: { result in
            switch result {
            case .success(let data):
                print("Image: \(data.image), from: \(data.cacheType)")
                
            case .failure(let error):
                print("Error: \(error)")
            }
        })
        
        cell.configure(with: book.volumeInfo)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? BookDetailViewController else { return }
        let book = sender as? Item
        destination.viewModel.book = book
    }
}

// MARK: - UITableViewDelegate
extension BooksTableViewController: BooksViewModelDelegate {

    func didLoadEvents() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // In case the list was updated by pull-refresh
        refreshControl?.endRefreshing()
    }
    
    func showBookDetails(_ book: Item) {
        performSegue(withIdentifier: "BookDetail", sender: book)
    }
    
    
    // MARK: - Error Alert
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Recarregar", style: UIAlertAction.Style.default) {
            (alert: UIAlertAction!) in
            self.viewModel.fetchBooks()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectBook(at: indexPath.row)
    }
}

// MARK: - UISearchBarDelegate
extension BooksTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String.empty
        searchBar.resignFirstResponder()
        
        viewModel.cancelSearch()
    }
    
}

// MARK: - UITextFieldDelegate
extension BooksTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
