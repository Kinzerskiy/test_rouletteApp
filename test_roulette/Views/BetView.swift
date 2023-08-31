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
    
    @State var betAmount: Int = 0
    @State private var showAlert: Bool = false
    
    var amountCompletion: (Int) -> ()
    
    var body: some View {
        VStack {
           
            Text("ID: \(authViewModel.appUser?.uuid ?? "Loading...")")
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
            
            HStack {
                Text("Win Rate: \(authViewModel.appUser?.winRate ?? 0)")
                    .fontWeight(.light)
                Spacer()
                Text("Coins: \(authViewModel.appUser?.coins ?? 0)")
                    .fontWeight(.light)
            }
            .padding([.top, .horizontal])
          
            if let coins = authViewModel.appUser?.coins {
                Stepper(value: $betAmount, in: 0...coins, step: 10) {
                    Text("Bet: \(betAmount)")
                }
                .padding([.horizontal])
                .onChange(of: betAmount) { newValue in
                    self.amountCompletion(newValue)
                }
            } else {
                Text("Fetching coins...")
                    .fontWeight(.light)
            }
        }
        .onAppear {
            authViewModel.fetchUserData()
            authViewModel.startListeningForUserData()
        }
        .onDisappear(perform: authViewModel.stopListening)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Your Bet"),
                message: Text("Your bet amount is \(betAmount) coins."),
                dismissButton: .default(Text("OK"))
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
        BetView(authViewModel: AuthViewModel(), betAmount: 10, amountCompletion: {_ in })
    }
}
