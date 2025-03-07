//
//  SecondView.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//

import SwiftUI

struct SecondView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Accessibility and SwiftUI Demo")
                    .font(.title)
                    .padding()
                
                // Demo for the comment view that toggles super favorite state.
                CommentDemoView()
                
                Divider()
                
                // Demo for a trip view with hover overlay, star rating, and custom accessibility actions.
                TripDemoView()
            }
            .padding()
        }
    }
}

struct CommentDemoView: View {
    @State private var isSuperFavorite = false

    var body: some View {
        VStack(spacing: 10) {
            Text("Comments")
                .font(.headline)
            
            HStack {
                Text("Absolutely beautiful, Jack!")
                    .lineLimit(1)
                Spacer()
                
                // Double tap toggles between a star and a sparkle.
                Image(systemName: isSuperFavorite ? "sparkles" : "star")
                    .font(.title)
                    .onTapGesture(count: 2) {
                        withAnimation {
                            isSuperFavorite.toggle()
                        }
                    }
                    // Apply the accessibility label only when it's a super favorite.
                    .accessibilityLabel("Super favorite", isEnabled: isSuperFavorite)
                    .accessibilityHint("Double tap to toggle super favorite")
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
        .padding()
    }
}

struct TripDemoView: View {
    @State private var isHovered = false
    let tripTitle = "Image of Baker Beach"
    // We'll use an integer for the star rating.
    let starRating: Int = 3
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Baker Beach")
                .accessibilityLabel("Baker beach")
            
            // Base image view (make sure you have an asset named "beach" in Assets.xcassets)
            let baseImage = Image("beach")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)
            
            // Combine the base image with any overlay (if needed).
            ZStack(alignment: .bottomTrailing) {
                baseImage
                // If you had an overlay, it would appear here.
            }
            // onHover works on macOS (and on iPadOS with a pointer) to toggle the overlay.
            .onHover { hovering in
                withAnimation {
                    isHovered = hovering
                }
            }
            // Combine the image into one accessible element.
            .accessibilityElement(children: .ignore)
            // Update the accessibility label to include the star rating.
            .accessibilityLabel("\(tripTitle), \(starRating) star rating")
            
            // Visual star rating display.
            HStack(spacing: 2) {
                ForEach(0..<starRating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            // Also add an accessibility label for the rating view if needed.
            .accessibilityHidden(true) // Hide from VoiceOver since it's included above.
        }
        .padding()
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
