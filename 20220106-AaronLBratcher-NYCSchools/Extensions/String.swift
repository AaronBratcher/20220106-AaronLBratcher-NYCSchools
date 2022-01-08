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

}
