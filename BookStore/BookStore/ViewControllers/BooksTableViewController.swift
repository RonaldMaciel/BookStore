//
//  ViewController.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit


final class BooksTableViewController: UITableViewController {
    // MARK: - Constants
    
    private var books = ["BOOK 1", "BOOK 2", "BOOK 3"]
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: - Configuration
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

    }


}
 
extension BooksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
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

