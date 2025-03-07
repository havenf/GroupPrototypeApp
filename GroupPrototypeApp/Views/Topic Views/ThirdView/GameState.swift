//
//  GameState.swift
//  GroupPrototypeApp
//
//  Created by Sean Perkins on 3/12/25.
//

import SwiftUI
class GameState: ObservableObject {
    @Published var score: Int = 0
    @Published var grid: [[Bool]] = Array(repeating: Array(repeating:false, count:5), count: 6)
    
    func resetGame(){
        score = 0
        grid = Array(repeating: Array(repeating:false, count: 5), count: 6)
        
        UIAccessibility.post(notification: .announcement, argument: "Game Reset!")
        
        objectWillChange.send()
    }
}
