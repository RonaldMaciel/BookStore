//
//  ViewController.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit


final class BooksTableViewController: UITableViewController {
    private var books = ["BOOK 1", "BOOK 2", "BOOK 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.rowHeight = 200
        tableView?.estimatedRowHeight = 200
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

