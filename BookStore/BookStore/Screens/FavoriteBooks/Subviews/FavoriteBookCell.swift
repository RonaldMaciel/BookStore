//
//  FavoriteBookCell.swift
//  BookStore
//
//  Created by Ronald on 08/10/24.
//

import UIKit

final class FavoriteBookCell: UITableViewCell {
    
    // MARK: - Attributes
    public static let identifier: String = "FavoriteBookCell"
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appearSmoothly()
        selectionStyle = .none
        
    }
    
    // MARK: - Setup & Configuration
    func appearSmoothly() {
        contentView.alpha = 0
        
        UIView.animate(withDuration: 0.73) {
            self.contentView.alpha = 1
        }
    }
    
    func configure(with bookName: String) {
        print("cell book name: \(bookName)")
        titleLabel.text = bookName
    }
}

