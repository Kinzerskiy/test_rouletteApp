//
//  BettingModel.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import Foundation
import SwiftUI

enum BetType: Equatable {
    case number(Int)
    case first12, second12, third12
    case range1_18, range19_36
    case even, odd
    case red, black
}

struct ActiveBet: Identifiable {
    var id = UUID()
    var type: BetType
    var amount: Double
}

class BettingModel: ObservableObject {
    
    @Published var balance: Double = 10000.0
    @Published var betAmount: Double = 0.0
    @Published var betNumber: Int? = nil
    
    func placeBet(on number: Int, amount: Double) {
        betNumber = number
        betAmount = amount
    }
    
    func resolveBet(finalIndex: Int?) {
        if let bet = betNumber, let final = finalIndex, bet == final {
            balance += betAmount * 35
        } else {
            balance -= betAmount
        }

        // Reset the bet
        betNumber = nil
        betAmount = 0.0
    }
}
