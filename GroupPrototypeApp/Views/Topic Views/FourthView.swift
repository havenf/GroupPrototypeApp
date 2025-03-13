//
//  FourthView.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//


import SwiftUI

struct FourthView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 1. Basic Dynamic Type - Uses a system font that scales automatically
                // The text will adjust based on the user's preferred text size settings
                Text("Dynamic Type Example")
                    .font(.title) // Uses system-defined title font
                    .dynamicTypeSize(.large) // Allows font to scale dynamically

                // 2. Supporting Dynamic Type with Preferred Font
                // This text will use Apple's built-in `.body` text style, which scales automatically
                Text("This text adjusts using Apple's built-in text styles.")
                    .font(.body) // Adapts to system text settings

                // 3. Using Custom Fonts with Dynamic Type Scaling
                // When using a custom font, Dynamic Type should be explicitly enabled for proper scaling
                Text("Custom Font Example")
                    .font(.custom("AvenirNext-Regular", size: 20)) // Custom font with base size of 20
                    .dynamicTypeSize(.xxLarge) // Ensures it scales according to user settings

                // 4. Handling Text Wrapping and Scaling
                // Demonstrates how to properly wrap text while allowing it to scale
                Text("A long piece of text that will automatically adjust and wrap based on the text size set by the user.")
                    .font(.body) // Uses system font style
                    .lineLimit(3) // Limits text to 3 lines to prevent excessive space usage
                    .minimumScaleFactor(0.5) // Shrinks text to 50% of its original size if necessary to fit

                // 5. Adjusting Font for Content Size Category in UIKit
                // This example integrates a UIKit UILabel that respects Dynamic Type settings
                DynamicUIKitTextView()
                    .frame(height: 60) // Ensures the label has enough space to expand when text size increases

                // 6. Displaying SF Symbols That Scale with Dynamic Type
                // SF Symbols automatically adjust in size when Dynamic Type settings change
                HStack {
                    Image(systemName: "textformat.size")
                        .font(.system(size: 24)) // Default size before scaling
                        .symbolRenderingMode(.hierarchical) // Uses hierarchical rendering for better contrast
                    Text("SF Symbol Scaling Enabled")
                        .font(.body) // Ensures text scales with Dynamic Type
                }

                // 7. Button with Dynamic Type Support
                // Ensures that button text adjusts dynamically along with other text elements
                Button(action: {}) {
                    Text("Dynamic Type Button")
                        .font(.body) // Button text scales with Dynamic Type
                        .padding() // Adds padding around text for better tap area
                        .frame(maxWidth: .infinity) // Expands to available space to avoid truncation
                        .background(Color.blue) // Background color for visibility
                        .foregroundColor(.white) // Text color contrast against background
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded edges for a modern look
                }
                .dynamicTypeSize(.large) // Ensures the button text remains accessible
            }
            .padding() // Adds spacing around all elements
            .frame(maxWidth: 800) // Restricts width to ensure proper layout adaptation
            .frame(maxHeight: .infinity) // Allows elements to expand if needed
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expands to fill available screen space
    }
}

// UIKit Integration for Dynamic Type
// This struct creates a UIKit UILabel that supports Dynamic Type within SwiftUI
struct DynamicUIKitTextView: UIViewRepresentable {
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body) // Uses Apple's preferred body text style
        label.adjustsFontForContentSizeCategory = true // Enables automatic scaling when user adjusts text size
        label.text = "UIKit Label - Adjusts for Content Size Category" // Sample text
        label.numberOfLines = 2 // Allows text to wrap into multiple lines if necessary
        label.textAlignment = .center // Ensures text is centered within the label
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {}
    }

