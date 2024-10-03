//
//  SearchBar+Extension.swift
//  BookStore
//
//  Created by Ronald on 02/10/24.
//

import Foundation
import UIKit

extension UISearchController {
    
    static func defaultSearchController(searchBarDelegate: UISearchBarDelegate, textFieldDelegate: UITextFieldDelegate) -> UISearchController {
        
        let searchController = UISearchController()
        
        // Sets searchbar appearence and behaiviour
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.returnKeyType = .done
        
        // Sets searchbar delegates
        searchController.searchBar.delegate = searchBarDelegate
        searchController.searchBar.searchTextField.delegate = textFieldDelegate
        
        return searchController
    }
    
}
