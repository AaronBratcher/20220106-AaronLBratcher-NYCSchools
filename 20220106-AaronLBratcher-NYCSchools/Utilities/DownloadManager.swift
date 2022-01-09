//
//  DownloadManager.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import Foundation
import Combine

enum DownloadError: Error {
    case download
    case parse
}

class DownloadManager: ObservableObject {
    static let shared = DownloadManager()
    private var subscriptions = Set<AnyCancellable>()
    
    typealias SchoolResults = Result<[School],DownloadError>
    func downloadSchools(completion: @escaping (SchoolResults) -> Void) {
        do {
            try NYCSchoolsAPI.retrieveSchools()
                .sink(receiveCompletion: { (ApiCompletion) in
                    switch ApiCompletion {
                    case .failure(_):
                        completion( .failure(.download))
                    case .finished:
                        break
                    }
                }) { schools in
                    completion(.success(schools))
                }
                .store(in: &subscriptions)
        } catch {
            completion(.failure(.download))
            return
            
        }
    }
    
    typealias ScoresDownloadResults = Result<[String: Scores],DownloadError>
    func cacheSatScores(completion: @escaping (ScoresDownloadResults) -> Void) {
        do {
            try NYCSchoolsAPI.retrieveScores()
                .sink(receiveCompletion: { (ApiCompletion) in
                    switch ApiCompletion {
                    case .failure(_):
                        completion(.failure(.download))
                    case .finished:
                        break
                    }
                }) { scores in
                    
                    let scoresDict = scores.reduce(into: [String: Scores]()) {
                        $0[$1.dbn] = $1
                    }
                    completion(.success(scoresDict))
                }
                .store(in: &subscriptions)
        } catch {
            completion(.failure(.download))
            return
            
        }
    }
}

//  This method of abstracting networking was adapted from https://www.vadimbulavin.com/modern-networking-in-swift-5-with-urlsession-combine-framework-and-codable/

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

enum NYCSchoolsAPI {
    static let agent = Agent()
    static let base = "https://data.cityofnewyork.us/resource/"
    static let schools = "s3k6-pzi2.json"
    static let scores = "f9bf-2cp4.json"
}

extension NYCSchoolsAPI {
    static func retrieveSchools() throws -> AnyPublisher<[School], Error> {
        guard let base = URL(string: NYCSchoolsAPI.base) else {
            throw DownloadError.download
        }
        let request = URLRequest(url: base.appendingPathComponent(NYCSchoolsAPI.schools))
        return agent.run(request)
    }
    
    static func retrieveScores() throws -> AnyPublisher<[Scores], Error> {
        guard let base = URL(string: NYCSchoolsAPI.base) else {
            throw DownloadError.download
        }
        let request = URLRequest(url: base.appendingPathComponent(NYCSchoolsAPI.scores))
        return agent.run(request)
    }
}
