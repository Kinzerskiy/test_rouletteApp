//
//  CombinedRouletteView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct CombinedRouletteView: View {
    
    @ObservedObject var model = RouletteModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                
                RouletteWheelView(model: model)
                RouletteTableView(model: model)
                
                
            }
        }
    }
}


struct CombinedRouletteView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedRouletteView()
    }
}
