//
//  RouletteWheelView.swift
//  test_roulette
//
//  Created by Mac Pro on 17.08.2023.
//

import SwiftUI

struct RouletteWheelView: View {
    
    @ObservedObject var model = RouletteViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(model.wheelOrder, id: \.self) { number in
                    
                    let index = model.wheelOrder.firstIndex(of: number) ?? 0
                    let segmentAngle = 360.0 / Double(model.wheelOrder.count)
                    let startingAngle = segmentAngle * Double(model.wheelOrder.firstIndex(of: 0)!)
                    let angle = Double(index) * segmentAngle - startingAngle - 95.0
                    let offsetAngle = (angle + segmentAngle / 2) * (.pi/180)
                    
                    
                    Path { path in
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        path.move(to: center)
                        path.addArc(center: center, radius: geometry.size.width / 2, startAngle: Angle(degrees: angle), endAngle: Angle(degrees: angle + segmentAngle), clockwise: false)
                    }
                    
                    .fill(index == model.activeIndex ? Color.white : model.color(for: number))
                    
                    Text("\(number)")
                        .foregroundColor((index == model.activeIndex && index == model.finalIndex && !model.spinning) ? .green : .white)
                    
                        .rotationEffect(Angle(degrees: 180))
                        .font(.system(size: 10))
                    
                        .position(
                            x: geometry.size.width / 2 + (geometry.size.width/2.5) * CGFloat(cos(offsetAngle)),
                            y: geometry.size.height / 2 + (geometry.size.height/2.5) * CGFloat(sin(offsetAngle))
                        )
                    
                }
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height)
            }
            .rotationEffect(Angle(degrees: model.wheelRotation))
            
            Button("Start") {
                model.startSpinning()
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
