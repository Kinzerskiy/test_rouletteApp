//
//  RouletteWheelView.swift
//  test_roulette
//
//  Created by Mac Pro on 17.08.2023.
//

import SwiftUI

struct RouletteWheelView: View {
    
    @State private var activeIndex: Int? = nil
    @State private var finalIndex: Int? = nil
    
    @State private var spinning: Bool = false
    @State private var rotationCount: Int = 10
    @State private var maxRotations: Int = Int.random(in: 1...3)
   
    @State private var wheelRotation: Double = 0.0
    
    
    func spinWheel() {
        if rotationCount >= maxRotations && activeIndex == finalIndex {
            spinning = false
            return
        }
        
        if spinning {
            _ = (finalIndex! - activeIndex! + wheelOrder.count) % wheelOrder.count
            let totalSegments = Double(maxRotations * wheelOrder.count + finalIndex!)
            let progress = 1.0 - Double(rotationCount * wheelOrder.count + activeIndex!) / totalSegments
            let baseDuration: Double = 0.1
            
            let totalDuration = baseDuration + baseDuration * progress * progress
            
            withAnimation(.linear(duration: totalDuration)) {
                if activeIndex == 0 {
                    rotationCount += 1
                }
                
                activeIndex = (activeIndex! + 1) % wheelOrder.count
                wheelRotation -= 360.0 / Double(wheelOrder.count)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                    spinWheel()
                }
            }
        }
    }
    
    let wheelOrder: [Int] = [0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26]
    
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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(wheelOrder, id: \.self) { number in
                    
                    let index = wheelOrder.firstIndex(of: number) ?? 0
                    let segmentAngle = 360.0 / Double(wheelOrder.count)
                    let startingAngle = segmentAngle * Double(wheelOrder.firstIndex(of: 0)!)
                    let angle = Double(index) * segmentAngle - startingAngle - 95.0
                    let offsetAngle = (angle + segmentAngle / 2) * (.pi/180)
                    
                    
                    Path { path in
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        path.move(to: center)
                        path.addArc(center: center, radius: geometry.size.width / 2, startAngle: Angle(degrees: angle), endAngle: Angle(degrees: angle + segmentAngle), clockwise: false)
                    }
                    
                    .fill(index == activeIndex ? Color.white : color(for: number))
                    
                    
                    // Number
                    Text("\(number)")
                        .foregroundColor((index == activeIndex && index == finalIndex && !spinning) ? .green : .white)
                        
                        .rotationEffect(Angle(degrees: Double(offsetAngle * (180.0 / .pi) - angle - segmentAngle / 2 )))
                        .position(
                            x: geometry.size.width / 2 + (geometry.size.width/2.5) * CGFloat(cos(offsetAngle)),
                            y: geometry.size.height / 2 + (geometry.size.height/2.5) * CGFloat(sin(offsetAngle))
                        )
                    
                }
                
                
                // Center circle
                Circle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height)
            }
            .rotationEffect(Angle(degrees: wheelRotation))
            
            Button("Start") {
                if !spinning {
                    spinning = true
                    rotationCount = 0
                    maxRotations = Int.random(in: 3...5)
                    finalIndex = Int.random(in: 20...36)
                    
                    activeIndex = Int.random(in: wheelOrder.indices)
                    
                    spinWheel()
                }
            }
            .padding(.bottom, 30)
            
            
        }
        
        .aspectRatio(1, contentMode: .fit)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RouletteWheelView()
    }
}
