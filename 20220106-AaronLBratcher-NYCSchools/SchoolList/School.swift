//
//  School.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import Foundation

struct School: Codable, Identifiable {
    var id: String {
        return dbn
    }
    
    let dbn: String
    let schoolName: String
    let location: String
    let phone: String
    let website: String?
    let lat: Double?
    let lon: Double?
}

#if DEBUG
var mockSchools: [School] {
    let schools = [
        School(dbn: "123", schoolName: "Main Elementary", location: "123 Main St. New York City, NY 10001", phone: "212-555-1230", website: nil, lat: 0, lon: 0),
        School(dbn: "345", schoolName: "Main Middle School", location: "345 Main St. New York City, NY 10001", phone: "212-555-3450", website: "https://store.apple.com", lat: 0, lon: 0),
        School(dbn: "789", schoolName: "Main High School", location: "789 Main St. New York City, NY 10001", phone: "212-555-7890", website: "https://developer.apple.com", lat: 0, lon: 0),
    ]
    
    return schools
}
#endif
