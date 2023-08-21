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
    @State private var betAmount: Int = 10
    
    var body: some View {
        VStack(spacing: 2) {
            Text("Anonnymus ID: \(authViewModel.appUser?.uuid ?? "Loading...")")
                .fontWeight(.light)
            Text("Win Rate: \(authViewModel.appUser?.winRate ?? 0)")
                .fontWeight(.light)
            if let coins = authViewModel.appUser?.coins {
                Stepper("Bet: \(betAmount)", value: $betAmount, in: 0...(coins/10))
            } else {
                Text("Fetching coins...")
                    .fontWeight(.light)
            }
            
            Button("Place Bet") {
                
            }
            .fontWeight(.light)
        }
        .onAppear {
            authViewModel.fetchUserData()
            authViewModel.startListeningForUserData()
        }
        .onDisappear(perform: authViewModel.stopListening)
    }
}


struct BetView_Previews: PreviewProvider {
    static var previews: some View {
        BetView(authViewModel: AuthViewModel())
    }
}
