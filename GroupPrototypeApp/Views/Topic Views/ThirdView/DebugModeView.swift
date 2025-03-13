//
//  DebugModeView.swift
//  GroupPrototypeApp
//
//  Created by Sean Perkins on 3/12/25.
//

import SwiftUI

struct DebugModeView:View{
    @State private var tetronimnoType = TetrominoType.allCases.randomElement()!
    @State private var position = (x:2, y:0) // grid position
    @State private var rotation: Int = 0
    @State private var currentShape: [(Int, Int)] = []
    @State private var gravityTimer: Timer?
    @State private var score: Int = 0
    @State private var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 5), count: 6) // Occupied spaces
    @State private var gridView: [[String]] = Array(repeating: Array(repeating: "⬜", count: 5), count: 6) // For rendering

    
    var body:some View{
        VStack{
            Text("Debug Mode: NO AR AVAILABLE").font(.headline).padding()
            Text("Score: \(score)").font(.title).padding()
            Text("Current Tetromino: \(tetronimnoType)").padding()
            
            GridView(gridView: gridView)
            
            HStack {
                Button("⬅️") { moveTetromino(dx: -1) }
                Button("🔄") { rotateTetromino() }
                Button("➡️") { moveTetromino(dx: 1) }
            }
            .padding()
            
            Button("⬇️ Hard Drop") { moveTetromino(dx: 0, dy: 1) }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)
            
            Button("Restart Game"){
                resetGame()
            }.padding().accessibilityLabel("Restart the game. Set score to zero")
        }
        
        .onAppear {
            let tetrominoType = TetrominoType.allCases.randomElement()!
            currentShape = getTetrominoShape(type: tetrominoType)
            updateGrid()
            startGravity()
        }
    }
    
    func resetGame(){
        score = 0
        grid = Array(repeating: Array(repeating:false, count:5), count: 6)
        spawnNewTetromino()
        
        UIAccessibility.post(notification: .announcement, argument: "Game Reset. Score is now Zero")
    }
    func moveTetromino(dx:Int, dy:Int = 0){
        let newX = position.x + dx
        let newY = position.y + dy
        
        for (blockX , blockY) in currentShape{
            let checkX = newX + blockX
            let checkY = newY + blockY
            
            if checkX < 0 || checkX >= 5 || checkY < 0 || checkY >= 6 || grid[checkY][checkX] {
                if (dy > 0){
                    lockTetromino()
                }
                return // prevent oob movement
            }
        }
        position = (newX, newY)
        updateGrid()
        
    }
    func rotateTetromino(){
        let rotatedShape = currentShape.map { (x, y) in
            (-y, x) // 90-degree rotation
        }

        for (blockX, blockY) in rotatedShape {
            let checkX = position.x + blockX
            let checkY = position.y + blockY
            if checkX < 0 || checkX >= 5 || checkY < 0 || checkY >= 6 {
                return // Prevent out-of-bounds rotation
            }
        }

        currentShape = rotatedShape
        updateGrid()
    }
    func lockTetromino(){
        for (blockX, blockY) in currentShape{
            let gridX = position.x + blockX
            let gridY = position.y + blockY
            
            if gridX >= 0 && gridX < 5 && gridY >= 0 && gridY < 6 {
                grid[gridY][gridX] = true
            }
        }
        clearFullRows()
        spawnNewTetromino()
    }
    
    func clearFullRows(){
        var rowsToClear: [Int] = []
        
        // Identify full rows
        for y in 0..<6 {
            if grid[y].allSatisfy({$0}){
                rowsToClear.append(y)
            }
        }
        
        guard !rowsToClear.isEmpty else { return }
        
        for row in rowsToClear {
            grid.remove(at: row)
            grid.insert(Array(repeating: false, count:5), at: 0)
        }
        updateScore(rowsToClear.count)
        updateGrid()
    }
    func updateScore(_ linesCleared: Int){
        let points = [0,100,300,500,800]
        score += points[min(linesCleared, points.count - 1 )]
    }
    func spawnNewTetromino(){
        let tetrominoType = TetrominoType.allCases.randomElement()!
        currentShape = getTetrominoShape(type: tetrominoType)
        position = (x:2, y:0)
        
        for (blockX, blockY) in currentShape {
                let checkX = position.x + blockX
                let checkY = position.y + blockY
                if checkX >= 0 && checkX < 5 && checkY >= 0 && checkY < 6 && grid[checkY][checkX] {
                    print("Game Over! Resetting")
                    resetGame()// Handle game over logic (TBD)
                    return
                }
            }

            updateGrid() // Refresh the grid
    }
    func updateGrid(){
        var displayGrid = Array(repeating: Array(repeating: "⬜", count: 5), count: 6)
        // render locked tetros
        for y in 0..<6{
            for x in 0..<5{
                if grid[y][x]{
                    displayGrid[y][x] = "🟩"
                }
            }
        }
        
        // render current tetro's
        for (blockX, blockY) in currentShape {
            let gridX = position.x + blockX
            let gridY = position.y + blockY
            
            if gridX >= 0 && gridX < 5 && gridY >= 0 && gridY < 6 {
                displayGrid[gridY][gridX] = "🟦" //active piece
            }
        }
        self.gridView = displayGrid
    }
    func startGravity(){
        gravityTimer?.invalidate()
        gravityTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            moveTetromino(dx: 0, dy: 1)
        }
    }
    func getTetrominoShape(type: TetrominoType) -> [(Int, Int)] {
        switch type {
        case .i: return [(0,0), (1,0), (-1,0),(2,0)]
        case .o: return [(0,0), (1,0), (0,1), (1,1)]
        case .t: return [(0,0), (-1,0), (1,0), (0,1)]
        case .l: return [(0,0), (0,-1), (0,1), (1,1)]
        case .j: return [(0,0), (0,-1), (0,1), (-1,1)]
        case .s: return [(0,0), (1,0), (0,1), (-1,1)]
        case .z: return [(0,0), (-1,0), (0,1), (1,1)]
        }
    }
    struct GridView: View {
        let gridView: [[String]]
        
        var body: some View{
            VStack(spacing: 2){
                ForEach(0..<gridView.count, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<gridView[row].count, id: \.self) { col in
                            Text(gridView[row][col].isEmpty ? "⬜" : gridView[row][col])
                                .frame(width: 40, height: 40)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
    }
}

