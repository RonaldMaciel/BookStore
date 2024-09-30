//
//  ViewController.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit


final class BooksTableViewController: UITableViewController {
    
    // MARK: - Attributes
    private let viewModel = BooksViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupViewModel()
    }
    
    // MARK: - Setup & Configuration
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.rowHeight = 200
        tableView?.estimatedRowHeight = 200
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                           target: self,
                                                           action: #selector(didTapFavoriteButton))
    }
    
    @objc func didTapFavoriteButton() {
        
        // show favorites
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }

}
 
// MARK: - UITableViewDataSource
extension BooksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = viewModel.allBooks[indexPath.row]
    
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as? BookCell else { return UITableViewCell() }
        
        // cell.configure(with: book)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BookCell", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BookDetailViewController
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
    
    // MARK: - Error Alert
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Recarregar", style: UIAlertAction.Style.default) {
            (alert: UIAlertAction!) in
            self.viewModel.fetchBooks()
        })
        self.present(alert, animated: true, completion: nil)
    }
}
