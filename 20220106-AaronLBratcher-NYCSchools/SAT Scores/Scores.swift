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
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numTakers = "num_of_sat_test_takers"
        case readingAvgScore = "sat_critical_reading_avg_score"
        case mathAvgScore = "sat_math_avg_score"
        case writingAvgScore = "sat_writing_avg_score"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dbn = try container.decode(String.self, forKey: .dbn)
        schoolName = try container.decode(String.self, forKey: .schoolName)
        let numTakers = try container.decode(String.self, forKey: .numTakers)
        let readingAvgScore = try container.decode(String.self, forKey: .readingAvgScore)
        let mathAvgScore = try container.decode(String.self, forKey: .mathAvgScore)
        let writingAvgScore = try container.decode(String.self, forKey: .writingAvgScore)
        
        self.numTakers = Int(numTakers)
        self.readingAvgScore = Int(readingAvgScore)
        self.mathAvgScore = Int(mathAvgScore)
        self.writingAvgScore = Int(writingAvgScore)
    }
}


#if DEBUG
var mockScores: [Scores] {
    let json = """
[
  {
    "dbn": "01M292",
    "school_name": "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES",
    "num_of_sat_test_takers": "29",
    "sat_critical_reading_avg_score": "355",
    "sat_math_avg_score": "404",
    "sat_writing_avg_score": "363"
  },
  {
    "dbn": "01M448",
    "school_name": "UNIVERSITY NEIGHBORHOOD HIGH SCHOOL",
    "num_of_sat_test_takers": "91",
    "sat_critical_reading_avg_score": "383",
    "sat_math_avg_score": "423",
    "sat_writing_avg_score": "366"
  },
  {
    "dbn": "01M450",
    "school_name": "EAST SIDE COMMUNITY SCHOOL",
    "num_of_sat_test_takers": "70",
    "sat_critical_reading_avg_score": "377",
    "sat_math_avg_score": "402",
    "sat_writing_avg_score": "370"
  },
  {
    "dbn": "01M458",
    "school_name": "FORSYTH SATELLITE ACADEMY",
    "num_of_sat_test_takers": "7",
    "sat_critical_reading_avg_score": "414",
    "sat_math_avg_score": "401",
    "sat_writing_avg_score": "359"
  }
]
"""
    let decoder = JSONDecoder()
    guard let jsonData = json.data(using: .utf8),
          let scores = try? decoder.decode([Scores].self, from: jsonData) else { return [] }
    return scores
}

var mockScoreDict: [String: Scores] {
    return ["01M292": mockScores[0], "01M448": mockScores[1], "01M450": mockScores[2], "01M458": mockScores[3]]
}
#endif
