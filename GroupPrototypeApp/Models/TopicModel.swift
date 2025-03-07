//
//  Topic.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//

import SwiftUI

struct TopicModel {
    let title: String
    let destination: AnyView
}

struct Topic {
    static let topics: [TopicModel] = [
        TopicModel(
                title: "Accessible Apps with SwiftUI and UIKit",
                destination: AnyView(SecondView())
            ),
        TopicModel(
                title: "Accessibility and SwiftUI",
                destination: AnyView(SecondView())
            ),
        TopicModel(
                title: "Accessible Spatial Experiences",
                destination: AnyView(ThirdView())
            ),
        TopicModel(
                title: "Dynamic Type",
                destination: AnyView(FourthView())
            ),
        TopicModel(
                title: "Assistive Access",
                destination: AnyView(FifthView())
            ),
        TopicModel(
                title: "Extend Speech Synthesis",
                destination: AnyView(SixthView())
            ),
        TopicModel(
                title: "Getting Started with Writing Tools",
                destination: AnyView(SeventhView())
            )
        ]
    }

