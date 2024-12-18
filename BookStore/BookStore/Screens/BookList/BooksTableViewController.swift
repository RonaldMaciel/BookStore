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
        setUpRefreshControl()
        setupNavigationBarFavoriteButton()
        setupSearchBar()
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                            target: self,
                                                            action: #selector(didTapFavoriteButtonViewController))
    }
    
    private func setupSearchBar() {
        self.navigationItem.searchController = UISearchController.defaultSearchController(searchBarDelegate: self,
                                                                                     textFieldDelegate: self)
    }
    
    
    @objc private func didTapFavoriteButtonViewController() {
        viewModel.didSelectFavorite()
    }
    
    private func setUpRefreshControl() {
        lazy var refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        refreshControl?.endRefreshing()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchBooks()
    }
}

// MARK: - UITableViewDataSource
extension BooksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as? BookCell else { return UITableViewCell() }
        
        
        let book = viewModel.allBooks[indexPath.row]
        cell.configure(with: book.volumeInfo)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? BookDetailViewController else { return }
        let book = sender as? Item
        destinationVC.viewModel.book = book
    }
}

// MARK: - UITableViewDelegate
extension BooksTableViewController: BooksViewModelDelegate {
    
    func didLoadEvents() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func showBookDetails(_ book: Item) {
        performSegue(withIdentifier: "BookDetail", sender: book)
    }
    
    func showFavoriteBooks() {
        performSegue(withIdentifier: "FavoriteBooks", sender: FavoriteBooksViewController())
    }
    
    
    // MARK: - Error Alert
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Recarregar",
                                      style: UIAlertAction.Style.default) { (alert: UIAlertAction!) in
            self.viewModel.fetchBooks()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectBook(at: indexPath.row)
    }
    
    // MARK: - Pagination
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        
        // position from the top of ScrollView, so we subtract the ScrollView height
        if position > (scrollView.contentSize.height - (scrollView.frame.size.height * 2)) {
            viewModel.fetchMoreBooks()
        }
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
