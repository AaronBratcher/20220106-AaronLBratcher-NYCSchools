//
//  ScoresView.swift
//  NYCSchools
//
//  Created by Aaron Bratcher on 1/7/22.
//

import SwiftUI

struct ScoresView: View {
    let scores: Scores?
    
    var body: some View {
        if let scores = scores {
            ScoresInnerView(schoolName: scores.schoolName, takers: scores.numTakers, avgReading: scores.readingAvgScore, avgMath: scores.mathAvgScore, avgWriting: scores.writingAvgScore)
        } else {
            CardView {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
                    .padding()
                Text("scoresView.error".localized)
                    .font(.headline)
                    .padding()
            }.padding()
        }
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScoresView(scores: mockScores[0])
            ScoresView(scores: nil)
        }
    }
}
