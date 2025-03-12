//
//  FifthView.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//


import SwiftUI

struct FifthView: View {
    var body: some View {
        VStack(spacing: 30) { // Arranges UI elements vertically
            // Large, easy-to-read title
            Text("Assistive Access Demo")
                .font(.largeTitle)
                .bold()
                .padding()
                .accessibilityLabel("Assistive Access Mode") // Improves VoiceOver support

            // Large, easy-to-press buttons with clear labels
            VStack(spacing: 20) {
                AssistiveButton(title: "Call Support", color: .blue, action: {
                    print("📞 Calling support...")
                })

                AssistiveButton(title: "Open Messages", color: .green, action: {
                    print("💬 Opening messages...")
                })

                AssistiveButton(title: "Exit Assistive Access", color: .red, action: {
                    showExitAlert()
                })
            }
            .padding()

            Spacer() // Pushes content to top for better accessibility
        }
        .padding()
        .background(Color(UIColor.systemGray6)) // ✅ Light gray for better contrast
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: - Function to Show Exit Alert
    func showExitAlert() {
        let alert = UIAlertController(
            title: "Exit Assistive Access",
            message: "Triple-click the side button to exit Assistive Access mode.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Displays alert in UIKit since SwiftUI doesn't support native alerts yet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true)
        }
    }
}

// MARK: - Custom Assistive Button Component
struct AssistiveButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            action() //  Executes assigned action when tapped
        }) {
            Text(title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, minHeight: 80) //  Ensures large tap area
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 40) // Adds extra padding for accessibility
        }
        .accessibilityLabel(title) // VoiceOver reads button title clearly
    }
}
