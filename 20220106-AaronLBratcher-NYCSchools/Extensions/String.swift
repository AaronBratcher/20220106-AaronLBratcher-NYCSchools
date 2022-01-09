//
//  String.swift
//  NYCSchools
//
//  Created by Aaron Bratcher on 1/7/22.
//

import Foundation
extension String {
    var localized: String {
        return String( format: NSLocalizedString(self, comment: ""))
    }

    func localized( _ args: CVarArg...) -> String {
        let resultString = String( format: NSLocalizedString(self, comment: ""), arguments: args)
        return resultString
    }
    
    func stripParentheticalText() -> String {
        var string = self
        if let leftIdx = string.firstIndex(of: "("), let rightIdx = string.firstIndex(of: ")") {
            let sansParens = String(string.prefix(upTo: leftIdx) + string.suffix(from: string.index(after: rightIdx)))
            string = sansParens
        }
        
        return string
    }
}
