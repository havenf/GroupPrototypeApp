//
//  MainView.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//


import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: FirstView()) {
                    Text("Accessible Apps with SwiftUI and UIKit")
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: SecondView()) {
                    Text("Accessibility and SwiftUI")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: ThirdView()) {
                    Text("Accessible Spatial Experiences")
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: FourthView()) {
                    Text("Dynamic Type")
                        .padding()
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: FifthView()) {
                    Text("Assistive Access")
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: SixthView()) {
                    Text("Extend Speech Synthesis")
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: SeventhView()) {
                    Text("Getting Started with Writing Tools")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Topics")
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
