//
//  String+Extension.swift
//  BookStore
//
//  Created by Ronald on 02/10/24.
//

import Foundation

extension String {
    
    static let empty = ""
    
    func containsIgnoringCase(_ substring: String) -> Bool {
        return self.lowercased().contains(substring.lowercased())
    }
}
