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
            List {
                // Use ForEach with an explicit id since Topic is not Identifiable.
                ForEach(Topic.topics, id: \.title) { topic in
                    NavigationLink(destination: topic.destination) {
                        Text(topic.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .cornerRadius(8)
                    }
                    .listRowInsets(EdgeInsets())
                    .padding()
                }
            }
            .navigationTitle("Topics")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
