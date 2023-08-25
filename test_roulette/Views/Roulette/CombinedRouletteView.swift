//
//  CombinedRouletteView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct CombinedRouletteView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var betViewModel: BetViewModel
    @ObservedObject var model: RouletteViewModel
    
    @Binding var path: NavigationPath
    
    
    init(path: Binding<NavigationPath>, authViewModel: AuthViewModel, betViewModel: BetViewModel, completion: @escaping (Int) -> ()) {
        
        self.authViewModel = authViewModel
        self.betViewModel = betViewModel
        
        self.model = RouletteViewModel(completion: { finalValue in
            betViewModel.calculateResult(result: finalValue) { winnings in
                if let user = authViewModel.appUser {
                    var mutableUser = user
                    mutableUser.coins += winnings
                    authViewModel.appUser = mutableUser
                    authViewModel.updateUserData(user: mutableUser)
                }
            }
        })
        _path = path
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    RouletteTableView(model: self.model, authViewModel: self.authViewModel, betTypeCompletion: { betType in
                        self.betViewModel.updateBetType(betType: betType)
                    })
                    .rotationEffect(.degrees(90))
                    .frame(width: geometry.size.height * 0.3)
                }
                .position(x: geometry.size.width * 0.3, y: geometry.size.height / 2)

              
                VStack(spacing: 30) {
                    RouletteWheelView(model: self.model)
                        .rotationEffect(.degrees(90))
                        .frame(width: geometry.size.height * 0.21)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    BetView(authViewModel: authViewModel, amountCompletion: { amount in
                        self.betViewModel.updateAmount(amount: amount)
                    })
                    .rotationEffect(.degrees(90))
                    .frame(width: geometry.size.height * 0.3)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button(action: {
                        self.model.startSpinning()
                        
                    }) {
                        Text("Start")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .rotationEffect(.degrees(90))
                }
                .padding(.leading, geometry.size.width * 0.5)
            }
            .padding(.top, 0)
        }
    }

}



struct CombinedRouletteView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedRouletteView(path: .constant(NavigationPath()), authViewModel: AuthViewModel(), betViewModel: BetViewModel(), completion: {_ in})
    }
}
