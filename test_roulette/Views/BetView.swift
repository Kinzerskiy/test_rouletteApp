//
//  BetView.swift
//  test_roulette
//
//  Created by Mac Pro on 21.08.2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth



struct BetView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var betViewModel: BetViewModel = BetViewModel()

    @State var betAmount: Int {
           didSet {
               betViewModel.betAmount = betAmount
           }
       }

    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 2) {
            Text("ID: \(authViewModel.appUser?.uuid ?? "Loading...")")
                .fontWeight(.light)
            Text("Win Rate: \(authViewModel.appUser?.winRate ?? 0)")
                .fontWeight(.light)
            Text("Coins: \(authViewModel.appUser?.coins ?? 0)")
                .fontWeight(.light)
            if let coins = authViewModel.appUser?.coins {
                Stepper(value: $betAmount, in: 0...(coins/10), step: 10) {
                    Text("Bet: \(betAmount)")
                }
            } else {
                Text("Fetching coins...")
                    .fontWeight(.light)
            }
            
            Button("Place Bet") {
    
                    betViewModel.bet(amount: betAmount, betType: .number(betAmount))
                    let result = 10
                    let winnings = betViewModel.calculateResult(result: result)
                   
            }
            .fontWeight(.light)
        }
        .onAppear {
            authViewModel.fetchUserData()
            authViewModel.startListeningForUserData()
        }
        .onDisappear(perform: authViewModel.stopListening)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Out of coins!"),
                message: Text("Gift for you - 100 coins!"),
                dismissButton: .default(Text("Resume game")) {
                    authViewModel.appUser?.coins += 100
                }
            )
        }
        .onReceive(authViewModel.$appUser) { user in
            if let coins = user?.coins, coins == 0 {
                showAlert = true
            }
        }
    }
}


struct BetView_Previews: PreviewProvider {
    static var previews: some View {
        BetView(authViewModel: AuthViewModel(), betAmount: 10)
    }
}
