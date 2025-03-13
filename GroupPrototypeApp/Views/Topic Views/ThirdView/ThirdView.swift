import SwiftUI
import RealityKit
import ARKit
import UIKit

struct ThirdView: View {
    @StateObject var gameState = GameState()
    var body: some View {
        //if ARConfiguration.isSupported {
          //  VStack{
            //    Text("Score: \(gameState.score)").font(.largeTitle).padding().accessibilityLabel("Score: \(gameState.score) points")
              //  ARViewContainer(gameState: gameState).edgesIgnoringSafeArea(.all)
                
                //Button("Restart Game"){
                  //  gameState.resetGame()
                //}
                //.padding()
                //.accessibilityLabel("Restart the game")
                
                
            //}
            
        //} else {
            DebugModeView()
        }
    //}
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var gameState: GameState
    func makeUIView(context: Context) -> ARView {
        // Configure AR Session
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        context.coordinator.gameState = gameState
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        let accessibilityOverlay = UIView(frame: .zero)
        accessibilityOverlay.isAccessibilityElement = true
        // Enable Direct Interaction
        arView.accessibilityTraits = [.allowsDirectInteraction]
        
        accessibilityOverlay.accessibilityLabel = "XR Tetris Game"
        accessibilityOverlay.accessibilityHint = "Swipe left or right to hear game updates"
        arView.addSubview(accessibilityOverlay)
        
        // Add Tap gestures
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSwipeLeft(_:)))
        swipeLeft.direction = .left
        
        let hold = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSwipeRight(_:)))
        swipeRight.direction = .right
        let tapToRotate = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapToRotate(_:)))
        
        arView.addGestureRecognizer(tapToRotate)
        arView.addGestureRecognizer(hold)
        arView.addGestureRecognizer(swipeRight)
        arView.addGestureRecognizer(swipeLeft)
        arView.addGestureRecognizer(tapGesture)
        arView.addGestureRecognizer(panGesture)
        arView.addGestureRecognizer(pinchGesture)
        
        // Setup Coordinator
        context.coordinator.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

class Coordinator: NSObject {
    var gameState: GameState?
    var gravityTimer: Timer?
    weak var arView: ARView?
    var currentShape: [(Int, Int)] = []
    var score: Int = 0
    var selectedEntity: ModelEntity?
    var grid: [[Bool]] = Array(repeating: Array(repeating:false,count:5), count:6)
    var position: (x: Int, y:Int) = (2,0)
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        
        let location = sender.location(in: arView)
        let results = arView.raycast(from: location, allowing: .existingPlaneInfinite, alignment: .horizontal)
        
        if let firstResult = results.first {
            // create an anchor entity at tap location
            let anchorEntity = AnchorEntity(world: firstResult.worldTransform)
            
            // Generate a random Tetromino
            let randomTetromino = TetrominoType.allCases.randomElement()!
            let tetrominoEntity = TetrominoFactory.createTetromino(type: randomTetromino)
            
            
            // Add 3D board entity
            let boardEntity = ModelEntity(mesh: .generateBox(size: [0.3, 0.01, 0.3])) // 30 cm * 1 cm * 30 cm
            boardEntity.position = SIMD3(x: 0, y: 0, z: 0)
            boardEntity.generateCollisionShapes(recursive: true)
            boardEntity.name = "TetrisBoard"
            
            // attach the board to the anchor
            anchorEntity.addChild(boardEntity)
            anchorEntity.addChild(tetrominoEntity)
            
            // add anchor to arview scene
            arView.scene.addAnchor(anchorEntity)
            
            // Ensure entity is stored for gestures
            selectedEntity = tetrominoEntity
            
            startGravity()
        }
    }
    @objc func handleSwipeLeft(_ sender: UISwipeGestureRecognizer){
        guard let entity = selectedEntity else {return}
        entity.position.x -= 0.1 // Move 10 cm left
    }
    @objc func handleSwipeRight(_ sender: UISwipeGestureRecognizer){
        guard let entity = selectedEntity else {return}
        entity.position.x += 0.1 // Move 10 cm right
    }
    @objc func handleTapToRotate(_ sender: UITapGestureRecognizer){
        guard let entity = selectedEntity else { return }
        entity.transform.rotation *= simd_quatf(angle: .pi/2, axis: SIMD3(0,0,1)) //Rotate 90 degrees
    }
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        
    }
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let entity = selectedEntity, let arView = arView else { return }
        
        let translation = sender.translation(in: arView)
        let moveX = Float(translation.x) * 0.001
        let moveZ = -Float(translation.y) * 0.001
        
        entity.position.x += moveX
        entity.position.z += moveZ
        
        sender.setTranslation(.zero, in: arView)
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let entity = selectedEntity else { return }
        
        let scale = Float(sender.scale)
        entity.scale = SIMD3(repeating: scale)
        
        sender.scale = 1.0
    }
    
    func isCollisionDetected(at newY: Float) -> Bool {
        let newGridY = Int(newY / 0.1)
        for (gridX,gridY) in getTetrominoBlockPosition(){
            let checkY = gridY + (newGridY - gridY)
            
            if (checkY < 0 || checkY >= 6 || grid[checkY][gridX]) {
                return true
            }
        }
        return false
    }
    func lockTetromino(){
        guard let entity = selectedEntity else {return}
        
        for(blockX, blockY) in getTetrominoBlockPosition(){
            let gridX = blockX
            let gridY = blockY
            
            if gridX >= 0 && gridX < 5 && gridY >= 0 && gridY < 6{
                grid[gridY][gridX] = true
            }
        }
        announceGameEvent("Tetromino locked in place")
        clearFullRows()
        spawnNewTetromino()
        let gridY = Int(entity.position.y / 0.1)
        grid[gridY] = Array(repeating: true, count: 5) // mark row occupied
    }
    
    func getTetrominoBlockPosition() -> [(Int,Int)]{
        var blockPositions: [(Int,Int)] = []
        
        for (blockX, blockY) in currentShape {
            let gridX = position.x + blockX
            let gridY = position.y + blockY
            
            if( gridX >= 0 && gridX < 5 && gridY >= 0 && gridY < 6){
                blockPositions.append((gridX, gridY))
            }
        }
        return blockPositions
    }
    
    
    func clearFullRows(){
        var rowsToClear: [Int] = []
        
        for y in 0..<6{
            if grid[y].allSatisfy({ $0 }){
                rowsToClear.append(y)
            }
        }
        guard !rowsToClear.isEmpty else {return}
        let clearedRows = rowsToClear.count
        // remove cleared rows and shift everything down
        for row in rowsToClear{
            announceGameEvent("\(clearedRows) line cleared")
            grid.remove(at: row)
            grid.insert(Array(repeating:false, count:5), at:0)
        }
        updateScore(rowsToClear.count)
    }
    func updateScore(_ linesCleared: Int){
        let points = [0,100,300,500,800]
        score += points[min(linesCleared,points.count-1)]
        print("Score: \(score)")
    }
    func spawnNewTetromino(){
        let spawnHeight: Float = 10
        let anchorEntity = AnchorEntity(world: SIMD3(0, spawnHeight, 0)) // spawn at top
        let randomTetromino = TetrominoType.allCases.randomElement()!
        currentShape = getTetrominoShape(type: randomTetromino)
        position = (x:2,y:0)
        let tetrominoEntity = TetrominoFactory.createTetromino(type: randomTetromino)
        
        anchorEntity.addChild(tetrominoEntity)
        arView?.scene.addAnchor(anchorEntity)
        selectedEntity = tetrominoEntity
        announceGameEvent("New Tetromino spawned")
    }
    func announceGameEvent(_ message: String){
        DispatchQueue.main.async{
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        
    }
    func getTetrominoShape(type: TetrominoType) -> [(Int,Int)]{
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
    func resetGame(){
        arView?.scene.anchors.removeAll()
        
        gameState?.resetGame()
        
        spawnNewTetromino()
    }
    func startGravity(){
        gravityTimer?.invalidate()//Stop previous timer
        gravityTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let entity = self.selectedEntity else { return }

            let nextPositionY = entity.position.y - 0.1
            
            // Check if the entity is at the bottom or colliding
            if self.isCollisionDetected(at: nextPositionY){
                self.lockTetromino()
                self.spawnNewTetromino()
            } else {
                entity.position.y = nextPositionY
            }
        }
    }
}
