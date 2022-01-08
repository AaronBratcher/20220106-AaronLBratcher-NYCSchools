//
//  Scores.swift
//  NYCSchools
//
//  Created by Aaron Bratcher on 1/7/22.
//

import Foundation

struct Scores: Codable {
    let dbn: String
    let schoolName: String
    let numTakers: Int?
    let readingAvgScore: Int?
    let mathAvgScore: Int?
    let writingAvgScore: Int?
}


#if DEBUG
var mockScores: [Scores] {
    let scores = [
        Scores(dbn: "123", schoolName: "Main Elementary", numTakers: 5, readingAvgScore: 100, mathAvgScore: 101, writingAvgScore: 102),
        Scores(dbn: "456", schoolName: "Main Middle School", numTakers: nil, readingAvgScore: nil, mathAvgScore: nil, writingAvgScore: nil),
        Scores(dbn: "789", schoolName: "Main High School", numTakers: 30, readingAvgScore: 300, mathAvgScore: 301, writingAvgScore: 302)
    ]
    
    return scores
}

var mockScoreDict: [String: Scores] {
    return ["123": mockScores[0], "456": mockScores[1], "789": mockScores[2]]
}
#endif
