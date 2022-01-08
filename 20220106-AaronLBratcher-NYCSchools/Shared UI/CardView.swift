//
//  CardView.swift
//  20220106-AaronLBratcher-NYCSchools
//
//  Created by Aaron Bratcher on 1/6/22.
//

import SwiftUI

public struct CardView<Content: View>: View {
    private let backgroundColor: Color
    private let cardBody: Content
        
    let cornerRadius: Double = 2
    
    /**
     - parameter cardBody: Content to show in the body of the card
     */
    public init(backgroundColor: Color = .white01,
                @ViewBuilder cardBody: () -> Content) {
        self.cardBody = cardBody()
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            cardBody
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        }
        .background(CardShape(cornerRadius: cornerRadius,
                              backgroundColor: backgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: .black, radius: 1, x: 0, y: 0.5)
    }
}

public struct CardShape: View {
    private let cornerRadius: Double
    private let backgroundColor: Color
    
    public init(cornerRadius: Double,
                backgroundColor: Color) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(.black, lineWidth: 1)
            .background(backgroundColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color.gray
                VStack(spacing: 16) {
                    CardView {
                        Text("Plain Card")
                            .padding(.vertical, 16.0)
                            .foregroundColor(.black01)
                    }
                    .padding(.horizontal, 16.0)
                    
                    CardView( backgroundColor: .pink) {
                        Text("Warning")
                            .padding(.vertical, 16.0)
                            .foregroundColor(.black01)
                    }
                    .padding(.horizontal, 16.0)
                }
            }
            
            ZStack {
                Color.gray
                VStack(spacing: 16) {
                    CardView {
                        Text("Plain Card")
                            .padding(.vertical, 16.0)
                            .foregroundColor(.black01)
                    }
                    .padding(.horizontal, 16.0)
                    
                    CardView(backgroundColor: .pink) {
                        Text("Warning")
                            .padding(.vertical, 16.0)
                            .foregroundColor(.black01)
                    }
                    .padding(.horizontal, 16.0)
                }
            }.environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
        }.edgesIgnoringSafeArea(.all)
    }
}
