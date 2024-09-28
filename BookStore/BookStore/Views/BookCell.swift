//
//  Untitled.swift
//  BookStore
//
//  Created by Ronald on 28/09/24.
//

import UIKit

final class BookCell: UITableViewCell {
    
    // MARK: - Constants
    public static let identifier: String = "BookCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        appearSmoothly()
        selectionStyle = .none
    }
    
    // MARK: - Configuration
    private func appearSmoothly() {
        contentView.alpha = 0
        
        UIView.animate(withDuration: 0.6) {
            self.contentView.alpha = 1
        }
    }
    
    private func configure(with book: BookModel) {
        //thumbnailImageView.image = book.thumbnail
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        
        if let thumbnailURL = book.thumbnail {
            
        }
        
    }
}
