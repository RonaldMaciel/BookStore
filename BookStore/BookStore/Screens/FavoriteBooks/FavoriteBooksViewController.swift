//
//  FavoriteBooksViewController.swift
//  BookStore
//
//  Created by Ronald on 08/10/24.
//

import UIKit

class FavoriteBooksViewController: UITableViewController {

    let viewModel = FavoriteBooksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTableView()
        setUpRefreshControl()
        setupViewModel()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.rowHeight = 200
        tableView?.estimatedRowHeight = 200
    }
    
    func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchFavoriteBooks()
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
}

// MARK: - UITableViewDataSource
extension FavoriteBooksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteBookCell.identifier) as? FavoriteBookCell else { return UITableViewCell() }
        
        let favoriteBook = viewModel.favorites[indexPath.row]
        cell.configure(with: favoriteBook.volumeInfo)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FavoriteBooksViewController: FavoriteBooksViewModelDelegate {
    func getFavoriteBook(with bookID: String) -> String {
        userDefaults.getFavorite(bookID)
    }
    
    func didLoadEvents() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // In case the list was updated by pull-refresh
        refreshControl?.endRefreshing()
    }
}
