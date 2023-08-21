//
//  CombinedRouletteView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct CombinedRouletteView: View {
    
    @ObservedObject var model = RouletteViewModel()
    
    @Binding var path: NavigationPath
    
        var body: some View {
            GeometryReader { geometry in

                VStack(alignment: .center) {

                    RouletteWheelView(model: model)
                        .rotationEffect(.degrees(90))
                        .frame(width: geometry.size.height * 0.18)
                        .offset(x: geometry.size.width  - geometry.size.height * 0.3)
                    
                    
                    
                    RouletteTableView(model: model)
                        .rotationEffect(.degrees(90))
                        .frame(width: geometry.size.height * 0.3)
                        .offset(x: geometry.size.width * 0.25 - geometry.size.height * 0.13)
                    
                }
                .background(Color.clear)
                .padding(.top, 50)
            }
        }
    }



struct CombinedRouletteView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedRouletteView(path: .constant(NavigationPath()))
    }
}
