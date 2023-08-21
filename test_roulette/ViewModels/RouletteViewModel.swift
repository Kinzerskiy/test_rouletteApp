//
//  RouletteViewModel.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

enum SpinDirection {
    case clockwise
    case counterClockwise
    
    mutating func toggle() {
        switch self {
        case .clockwise:
            self = .counterClockwise
        case .counterClockwise:
            self = .clockwise
        }
    }
}

class RouletteViewModel: ObservableObject {
    
    @Published var activeIndex: Int? = nil
    @Published var finalIndex: Int? = nil
    
    @Published var spinning: Bool = false
    @Published var rotationCount: Int = 10
    @Published var maxRotations: Int = Int.random(in: 2...5)
    @Published var wheelRotation: Double = 0.0
    @Published var spinDirection: SpinDirection = .clockwise
    
    
    let wheelOrder: [Int] = [0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26]
    
    func spinWheel() {
        if rotationCount >= maxRotations && activeIndex == finalIndex {
            spinning = false
            return
        }
        
        if spinning {
            let totalSegments = Double(maxRotations * wheelOrder.count)
            let progress = 1.0 - Double(rotationCount * wheelOrder.count + activeIndex!) / totalSegments
            let baseDuration: Double = 0.05
            let totalDuration = baseDuration + baseDuration * (1 - progress)
            
            withAnimation(.linear(duration: totalDuration)) {
                if activeIndex == wheelOrder.count - 1  {
                    rotationCount += 1
                }
                
                activeIndex = (spinDirection == .clockwise ? (activeIndex! + 1) : (activeIndex! - 1 + wheelOrder.count)) % wheelOrder.count
                wheelRotation += (spinDirection == .clockwise ? 1 : -1) * (360.0 / Double(wheelOrder.count))
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                self.spinWheel()
            }
        }
    }
    
    func startSpinning() {
        if !spinning {
            spinning = true
            rotationCount = 0
            maxRotations = Int.random(in: 3...5)
            finalIndex = Int.random(in: 1...36)
            activeIndex = Int.random(in: wheelOrder.indices)
            spinWheel()
            
            spinDirection.toggle()
        }
    }
    
    
    func color(for number: Int) -> Color {
        switch number {
        case 0:
            return .green
        case 32, 19, 21, 25, 34, 27, 36, 30, 23, 5, 16, 1, 14, 9, 18, 7, 12, 3:
            return .red
        default:
            return .black
        }
    }
}
