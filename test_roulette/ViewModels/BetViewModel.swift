//
//  BetViewModel.swift
//  test_roulette
//
//  Created by Mac Pro on 21.08.2023.
//

import Foundation
import SwiftUI


enum BetType: Equatable {
    case firstThird
    case secondThird
    case thirdThird
    case oneEighteen
    case nineghtingThirtySix
    case number(Int)
    case odd
    case even
    case red
    case black
    case firstLine
    case secondLine
    case thirdLine
}

struct Bet {
    var amount: Int
    var betType: BetType
}

class BetViewModel: ObservableObject {
    
    @Published var currentBet: Bet?
    @Published var betAmount: Int?
    
    var completion: ((Int) -> ())?

    func updateBetType(betType: BetType) {
        if currentBet != nil {
            currentBet?.betType = betType
        } else {
            currentBet = .init(amount: 0, betType: betType)
        }
    }
    
    func updateAmount(amount: Int) {
        if currentBet != nil {
            currentBet?.amount = amount
        } else {
            currentBet = .init(amount: 0, betType: .red)
        }
    }
    
    func resetBet() {
        currentBet = nil
    }
    

    
    func calculateResult(result: Int) {
        defer {
            
            resetBet()
        }

        guard let currentBet = currentBet else {
            completion?(0)
            return
            }
        
        var winningsOrLosses = 0

        switch currentBet.betType {
        case .number(let number):
            if number == result {
                winningsOrLosses = currentBet.amount * 35
            } else {
                winningsOrLosses = -currentBet.amount
            }
        case .odd:
            winningsOrLosses = result % 2 != 0 ? currentBet.amount * 2 : -currentBet.amount
        case .even:
            winningsOrLosses = result % 2 == 0 ? currentBet.amount * 2 : -currentBet.amount
        case .red:
            winningsOrLosses = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36].contains(result) ? currentBet.amount * 2 : -currentBet.amount
        case .black:
            winningsOrLosses = [2, 4, 6, 8, 11, 10, 13, 15, 17, 20, 24, 22, 26, 29, 28, 31, 33, 35].contains(result) ? currentBet.amount * 2 : -currentBet.amount
        case .firstThird:
            winningsOrLosses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].contains(result) ? currentBet.amount * 3 : -currentBet.amount
        case .secondThird:
            winningsOrLosses = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24].contains(result) ? currentBet.amount * 3 : -currentBet.amount
        case .thirdThird:
            winningsOrLosses = [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36].contains(result) ? currentBet.amount * 3 : -currentBet.amount
        case .oneEighteen:
            winningsOrLosses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].contains(result) ? currentBet.amount * 2 : -currentBet.amount
        case .nineghtingThirtySix:
            winningsOrLosses = [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36].contains(result) ? currentBet.amount * 2 : -currentBet.amount
        case .firstLine:
            winningsOrLosses = [1, 3, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34].contains(result) ? currentBet.amount * 3 : -currentBet.amount
        case .secondLine:
            winningsOrLosses = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35].contains(result) ? currentBet.amount * 3 : -currentBet.amount
        case .thirdLine:
            winningsOrLosses = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36].contains(result) ? currentBet.amount * 3 : -currentBet.amount
        }
        completion?(winningsOrLosses)
    }
    
    
}
