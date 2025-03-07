//
//  TetrominoFactory.swift
//  GroupPrototypeApp
//
//  Created by Sean Perkins on 3/12/25.
//

import RealityKit
import UIKit

enum TetrominoType: CaseIterable {
    case i
    case j
    case l
    case o
    case s
    case t
    case z
}

class TetrominoFactory {
    static func createTetromino(type: TetrominoType) -> ModelEntity {
        let blockSize: Float = 0.1
        let color = getColor(for: type)
        
        //Define Tetromino shapes using relative positions
        let shapes:[TetrominoType: [(Float,Float)]] = [
            .i: [(0,0), (1,0), (-1,0),(2,0)],
            .o: [(0,0), (1,0), (0,1), (1,1)],
            .t: [(0,0), (-1,0), (1,0), (0,1)],
            .l: [(0,0), (0,-1), (0,1), (1,1)],
            .j: [(0,0), (0,-1), (0,1), (-1,1)],
            .s: [(0,0), (1,0), (0,1), (-1,1)],
            .z: [(0,0), (-1,0), (0,1), (1,1)]
        ]
        
        let tetrominoEntity = ModelEntity()
        
        if let positions = shapes[type]{
            for(x,y) in positions {
                let block = createBlock(size:blockSize, color:color)
                block.position = SIMD3( x * blockSize, y*blockSize, 0)
                tetrominoEntity.addChild(block)
            }
        }
        
        return tetrominoEntity
    }
    private static func createBlock(size: Float, color: UIColor) -> ModelEntity {
        let block = ModelEntity(mesh: .generateBox(size: SIMD3(size, size, size)))
        block.model?.materials = [SimpleMaterial(color:color, isMetallic: false)]
        return block
    }
    
    private static func getColor(for type: TetrominoType) -> UIColor {
        switch type {
        case .i: return .cyan
        case .o: return .yellow
        case.t: return .purple
        case.l: return .orange
        case.j: return .blue
        case.s: return .green
        case.z: return .red
            
        }
    }
}
