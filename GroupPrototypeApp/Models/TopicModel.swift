//
//  Topic.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//

import SwiftUI

struct TopicModel {
    let title: String
    let imageName: String
    let destination: AnyView
}

struct Topic {
    static let topics: [TopicModel] = [
        TopicModel(
                title: "Accessibility and SwiftUI",
                imageName: "accessibilitySwiftUI",
                destination: AnyView(SecondView())
            ),
        TopicModel(
                title: "Accessible Spatial Experiences",
                imageName: "spatialExperiences",
                destination: AnyView(ThirdView())
            ),
        TopicModel(
                title: "Dynamic Type",
                imageName: "dynamicType",
                destination: AnyView(FourthView())
            ),
        TopicModel(
                title: "Assistive Access",
                imageName: "assistiveAccess",
                destination: AnyView(FifthView())
            ),
        TopicModel(
                title: "Extend Speech Synthesis",
                imageName: "speechSynthesis",
                destination: AnyView(SixthView())
            ),
        TopicModel(
                title: "Getting Started with Writing Tools",
                imageName: "writingTools",
                destination: AnyView(SeventhView())
            )
        ]
    }

