//
//  DownloadManager.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import Foundation
import CodableCSV

enum DownloadError: Error {
    case download
    case parse
}

class DownloadManager: ObservableObject {
    static let shared = DownloadManager()
    private var satScoreCache: [String: Scores] = [:]
    
    typealias SchoolResults = Result<[School],DownloadError>
    func downloadSchools(completion: (SchoolResults) -> Void) {
        let results: SchoolResults
        defer {
            completion(results)
        }
        
        guard let rows = readCVSFile("2017_DOE_High_School_Directory") else {
            results = .failure(.parse)
            return
        }
        
        var schools: [School] = []
        var firstRow = true
        for row in rows {
            if firstRow {
                firstRow.toggle()
                continue
            }
            
            var location = row[18]
            var lat: Double?
            var lon: Double?
            
            // extract Lat and Lon
            let regex = "\\((.*?)\\)"
            if let latLonRange = location.range(of: regex, options: .regularExpression) {
                let latLon = String(location[latLonRange]).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
               
                let values = latLon.split(separator: ",")
                if values.count == 2 {
                    lat = Double(values[0])
                    lon = Double(values[1])
                }
            }

            location = stripParens(from: location)
            
            var website = row[22]
            if !website.starts(with: "https://") && !website.starts(with: "http://") {
                website = "https://\(website)"
            }
            
            let school = School(dbn: row[0], schoolName: row[1], location: location, phone: row[19], website: website, lat: lat, lon: lon)
            schools.append(school)
        }
        
        results  = .success(schools)
    }
    
    typealias ScoresDownloadResults = Result<[String: Scores],DownloadError>
    func cacheSatScores(completion: @escaping (ScoresDownloadResults) -> Void) {
        DispatchQueue.global().async {
            guard let rows = self.readCVSFile("2012_SAT_Results") else {
                let results: ScoresDownloadResults = .failure(.parse)
                completion(results)
                return
            }
            
            var scores: [String: Scores] = [:]
            var firstRow = true
            for row in rows {
                if firstRow {
                    firstRow.toggle()
                    continue
                }
                
                let dbn = row[0]
                let results = Scores(dbn: dbn, schoolName: row[1], numTakers: Int(row[2]), readingAvgScore: Int(row[3]), mathAvgScore: Int(row[4]), writingAvgScore: Int(row[5]))
                scores[dbn] = results
            }
            
            let results: ScoresDownloadResults = .success(scores)
            completion(results)
        }
    }
    
    func readCVSFile(_ file: String) -> [[String]]? {
        guard let url = Bundle.main.url(forResource:file, withExtension: "csv"),
              let data = try? Data(contentsOf: url) else { return nil }
        
        guard let readerFile = try? CSVReader.decode(input: data) else {
            return nil
        }
        
        return readerFile.rows
    }
    
    private func stripParens(from string: String) -> String {
        var string = string
        if let leftIdx = string.firstIndex(of: "("), let rightIdx = string.firstIndex(of: ")") {
            let sansParens = String(string.prefix(upTo: leftIdx) + string.suffix(from: string.index(after: rightIdx)))
            string = sansParens
        }
        
        return string
    }
}
