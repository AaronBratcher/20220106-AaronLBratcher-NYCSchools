//
//  ScoresInnerView.swift
//  NYCSchools
//
//  Created by Aaron Bratcher on 1/7/22.
//

import SwiftUI

struct ScoresInnerView: View {
    let schoolName: String
    let takers: Int?
    let avgReading: Int?
    let avgMath: Int?
    let avgWriting: Int?
    
    var body: some View {
        CardView {
            Text(schoolName)
                .bold()
                .font(.headline)
                .padding(.top, 8)
            Divider().padding()
            VStack {
                HStack {
                    Text("scoresView.takers".localized)
                    if let takers = takers {
                        Text("\(takers)")
                    } else {
                        Text("NA")
                    }
                }
                HStack {
                    Text("scoresView.reading".localized)
                    if let avgReading = avgReading {
                        Text("\(avgReading)")
                    } else {
                        Text("NA")
                    }
                }
                HStack {
                    Text("scoresView.math".localized)
                    if let avgMath = avgMath {
                        Text("\(avgMath)")
                    } else {
                        Text("NA")
                    }
                }
                HStack {
                    Text("scoresView.writing".localized)
                    if let avgWriting = avgWriting {
                        Text("\(avgWriting)")
                    } else {
                        Text("NA")
                    }
                }.padding(.bottom, 8)
            }
        }.padding()
    }
}

struct ScoresInnerView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresInnerView(schoolName: "Main Elementary", takers: 100, avgReading: 101, avgMath: 102, avgWriting: 103)
    }
}
