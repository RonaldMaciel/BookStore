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
    
    func occurences(of search: String) -> Int {
        guard search.count > 0 else {
            preconditionFailure()
        }
        
        let shrunk = self.replacingOccurrences(of: search, with: "")
        
        return (self.count - shrunk.count)/search.count
    }
}
