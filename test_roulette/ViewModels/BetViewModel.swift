//
//  BetViewModel.swift
//  test_roulette
//
//  Created by Mac Pro on 21.08.2023.
//

import Foundation
import SwiftUI

class BetViewModel: ObservableObject {
    @Published var betAmount: Int = 10
    var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func placeBet() {
        guard var user = authViewModel.appUser else {
            return
        }
        
        // Deduct the bet amount from the user's coins
        user.coins -= betAmount

        // Update the win rate (the formula for calculating win rate can be modified as needed)
        user.winRate = (user.winRate + 1) / 2  // Example formula
        
        // Update the user data in Firebase
        // This will involve a call to Firebase to update the user's data,
        // for this, you might have a function in your `AuthViewModel` or a separate Firebase service class.
        authViewModel.updateUserData(user: user)
    }
}
