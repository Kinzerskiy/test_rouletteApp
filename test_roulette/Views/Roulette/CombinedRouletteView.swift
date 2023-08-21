//
//  CombinedRouletteView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct CombinedRouletteView: View {
    
    @ObservedObject var model = RouletteViewModel()
    @ObservedObject var authViewModel = AuthViewModel()
    
    @Binding var path: NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            
            HStack(alignment: .center) {
                
                RouletteTableView(model: model)
                    .rotationEffect(.degrees(90))
                    .frame(width: geometry.size.height * 0.3)
                    .offset(x: geometry.size.width * 0.22 - geometry.size.height * 0.11)
                    .padding(3)
                
                
                
                VStack {
                    RouletteWheelView(model: model)
                        .rotationEffect(.degrees(90))
                        .frame(width: geometry.size.height * 0.2)
                        .padding(.bottom, 30)
                    
                    BetView(authViewModel: authViewModel)
                        .rotationEffect(.degrees(90))
                        .frame(width: geometry.size.height * 0.3)
                        .padding(.top, 60)
                        .offset(x: geometry.size.width * 0.2 - geometry.size.height * 0.12)
                        .padding(.bottom, 30)
                    
                    Button(action: {
                        model.startSpinning()
                    }) {
                        Text("Start")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .rotationEffect(.degrees(90))
                    .padding(.top, 60)
                }
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
