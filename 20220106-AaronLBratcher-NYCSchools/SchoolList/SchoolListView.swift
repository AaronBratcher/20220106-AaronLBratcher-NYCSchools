//
//  ContentView.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import SwiftUI

struct SchoolListView: View {
    @StateObject var viewModel = SchoolListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.loadingStatus {
                case .complete:
                    SchoolsView(schools: viewModel.schools, websiteAction: { url in
                        viewModel.showWebsite(url)
                    }, mapAction: { school in
                        viewModel.showMap(for: school)
                    }, phoneAction: { school in
                        viewModel.call(school)
                    }, scores: $viewModel.scores
                    )
                case .loading:
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(2)
                            .padding()
                        Text("schoolListView.loading".localized)
                            .font(.title)
                    }
                case .error:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.red)
                        .frame(width: 32, height: 32)
                    Text("schoolListView.error".localized)
                        .font(.headline)
                }
            }.navigationTitle("schoolListView.title".localized)
        }
    }
}

struct SchoolListView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolListView()
    }
}
