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
    }
    
    private func setUpRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        
    }
    
    @objc private func handleRefresh() {
        
    }
}

// MARK: - UITableViewDataSource
extension FavoriteBooksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favorites.count
        
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
    func didLoadEvents() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // In case the list was updated by pull-refresh
        refreshControl?.endRefreshing()
    }
}
