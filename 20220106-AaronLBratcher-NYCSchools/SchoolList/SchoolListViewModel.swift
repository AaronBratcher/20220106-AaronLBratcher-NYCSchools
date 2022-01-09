//
//  SchoolListViewModel.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import Foundation
import SwiftUI
import MapKit

class SchoolListViewModel: ObservableObject {
    @Published var schools: [School] = []
    @Published var loadingStatus: LoadingStatus = .loading
    @Published var scores: [String: Scores]?
    @Published var searchString: String = "" {
        didSet {
            if searchString.count < 2 {
                schools = allSchools
                return
            }
            
            schools = allSchools.filter({ $0.schoolName.contains(searchString) })
        }
    }
    
    lazy var showPhone: Bool = {
        if let url = URL(string: "tel://\(312-555-1212)"), UIApplication.shared.canOpenURL(url) {
            return true
        } else {
            return false
        }
    }()
    
    private let downloadManager: DownloadManager
    private var allSchools: [School] = []
    
    init(downloadManager: DownloadManager = DownloadManager.shared) {
        self.downloadManager = downloadManager
        
        // this would be a good place to use the new async/await syntax
        downloadManager.downloadSchools() { [weak self] results in
            guard let self = self else { return }

            switch results {
            case .success(let schools):
                DispatchQueue.main.async {
                    self.allSchools = schools
                    self.schools = schools
                    self.loadingStatus = .complete
                }
            case .failure(_):
                self.loadingStatus = .error
            }
        }
        
        downloadManager.cacheSatScores() { [weak self] results in
            guard let self = self else { return }
            if case .success(let scores) = results {
                DispatchQueue.main.async {
                    self.scores = scores
                }
            }
        }
    }
    
    func showMap(for school: School) {
        guard let lat = school.lat, let lon = school.lon else { return }
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = school.schoolName
        mapItem.openInMaps(launchOptions: options)
    }
    
    func call(_ school: School) {
        if let url = URL(string: "tel://\(school.phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showWebsite(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
