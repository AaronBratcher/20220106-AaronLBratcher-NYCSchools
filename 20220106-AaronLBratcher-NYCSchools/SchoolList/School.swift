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
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case location
        case phone = "phone_number"
        case website
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dbn = try container.decode(String.self, forKey: .dbn)
        schoolName = try container.decode(String.self, forKey: .schoolName)
        
        let location = try container.decode(String.self, forKey: .location)
        
        // extract Lat and Lon
        let regex = "\\((.*?)\\)"
        if let latLonRange = location.range(of: regex, options: .regularExpression) {
            let latLon = String(location[latLonRange]).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
           
            let values = latLon.split(separator: ",")
            if values.count == 2 {
                lat = Double(values[0])
                lon = Double(values[1])
            } else {
                lat = nil
                lon = nil
            }
        } else {
            lat = nil
            lon = nil
        }

        self.location = location.stripParentheticalText()
        phone = try container.decode(String.self, forKey: .phone)
        
        var website = try container.decode(String.self, forKey: .website)
        if !website.starts(with: "https://") && !website.starts(with: "http://") {
            website = "https://\(website)"
        }
        self.website = website
    }
}

#if DEBUG
var mockSchools: [School] {
    let json = """
[
  {
    "dbn": "02M260",
    "school_name": "Clinton School Writers & Artists, M.S. 260",
    "location": "10 East 15th Street, Manhattan NY 10003 (40.736526, -73.992727)",
    "phone_number": "212-524-4360",
    "website": "www.theclintonschool.net",
  },
  {
    "dbn": "21K728",
    "school_name": "Liberation Diploma Plus High School",
    "location": "2865 West 19th Street, Brooklyn, NY 11224 (40.576976, -73.985413)",
    "phone_number": "718-946-6812",
    "website": "schools.nyc.gov/schoolportals/21/K728",
  },
  {
    "dbn": "08X282",
    "school_name": "Women's Academy of Excellence",
    "location": "456 White Plains Road, Bronx NY 10473 (40.815043, -73.85607)",
    "phone_number": "718-542-0740",
    "website": "schools.nyc.gov/SchoolPortals/08/X282",
  },
  {
    "dbn": "17K548",
    "school_name": "Brooklyn School for Music & Theatre",
    "location": "883 Classon Avenue, Brooklyn NY 11225 (40.669805, -73.960689)",
    "phone_number": "718-230-6250",
    "website": "www.bkmusicntheatre.com",
  }
]
"""
    let decoder = JSONDecoder()
    guard let jsonData = json.data(using: .utf8),
          let schools = try? decoder.decode([School].self, from: jsonData) else { return [] }
    return schools
}
#endif
