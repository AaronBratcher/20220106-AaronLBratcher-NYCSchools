//
//  SchoolsView.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import SwiftUI

struct SchoolsView: View {
    let schools: [School]
    let websiteAction: ((URL) -> Void)
    let mapAction: ((School) -> Void)
    let phoneAction: ((School) -> Void)
    @Binding var scores: [String: Scores]?
    
    @State var showScores: Bool = false
    @State var schoolScores: Scores?
    
    var body: some View {
        ScrollView {
            ForEach(schools) { school in
                CardView {
                    VStack {
                        HStack {
                            Group {
                                VStack(alignment: .leading) {
                                    Text(school.schoolName)
                                        .bold()
                                        .font(.headline)
                                    Text(school.location)
                                        .font(.body)
                                    Text(school.phone)
                                        .font(.body)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                if school.lat != nil && school.lon != nil {
                                    Image(systemName: "mappin.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                        .onTapGesture() {
                                            mapAction(school)
                                        }
                                }
                                Spacer()
                                if let url = URL(string: "tel://\(school.phone)"), UIApplication.shared.canOpenURL(url) {
                                    Image(systemName: "phone.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                        .onTapGesture() {
                                            phoneAction(school)
                                        }
                                }
                            }
                        }

                        Divider().padding(.bottom, 4)

                        HStack(spacing: 40) {
                            if let website = school.website, let websiteAction = websiteAction, let url = URL(string: website) {
                                Button("Website") {
                                    websiteAction(url)
                                }
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                            
                            if let scores = scores, scores[school.id] != nil {
                                Button("SAT Scores") {
                                    schoolScores = scores[school.id]
                                    showScores = true
                                }.buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }.padding()
                }.sheet(isPresented: $showScores) {
                    ScoresView(scores: schoolScores)
                }
            }.padding(4)
        }
    }
}

struct SchoolsView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolsView(schools: mockSchools, websiteAction: { url in
        }, mapAction: { school in
        }, phoneAction: { school in
        }, scores: .constant(nil))
        
        SchoolsView(schools: mockSchools, websiteAction: { url in
        }, mapAction: { school in
        }, phoneAction: { school in
        }, scores: .constant(mockScoreDict))
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
    }
}
