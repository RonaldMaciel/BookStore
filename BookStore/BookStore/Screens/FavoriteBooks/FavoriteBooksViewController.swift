//
//  FavoriteBooksViewController.swift
//  BookStore
//
//  Created by Ronald on 08/10/24.
//

import UIKit

final class FavoriteBooksViewController: UITableViewController {
    
    // MARK: - Attributes
    private let viewModel = FavoriteBooksViewModel()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setUpRefreshControl()
        setupViewModel()
    }
    
    // MARK: - Setup & Configuration
    func setupTableView() {
        self.navigationItem.title = "Favorite Books"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.rowHeight = 100
        tableView?.estimatedRowHeight = 100
    }
    
    func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchFavoriteBooks()
    }
    
    private func setUpRefreshControl() {
        lazy var refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(handleRefresh),
                                 for: UIControl.Event.valueChanged)
        
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
        return self.viewModel.favoriteBooksNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoriteBookName = viewModel.favoriteBooksNames[indexPath.row]
        print("cell book name: \(favoriteBookName) at \(indexPath.row)\n")
        
        guard let favoriteBookCell = tableView.dequeueReusableCell(withIdentifier: FavoriteBooksCell.identifier) as? FavoriteBooksCell else {
            print("couldn't create favorite book cell with identifier: \(FavoriteBooksCell.identifier)")
            return UITableViewCell()
        }
        
        favoriteBookCell.configure(with: favoriteBookName)
        
        
        return favoriteBookCell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteBooksViewController: FavoriteBooksViewModelDelegate {
    func getFavoriteBookName(with bookID: String) -> String {
        userDefaults.getFavorite(bookID)
    }
    
    func didLoadEvents() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
}
