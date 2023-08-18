//
//  BetManager.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import Foundation

class BetManager: ObservableObject {
    @Published var activeBets: [ActiveBet] = []
    
    func toggleBet(type: BetType) {
        if let existingBetIndex = activeBets.firstIndex(where: { $0.type == type }) {
            activeBets.remove(at: existingBetIndex)
        } else {
            let betAmount = 10.0 // просто пример, здесь можно добавить дополнительную логику
            let bet = ActiveBet(type: type, amount: betAmount)
            activeBets.append(bet)
        }
    }
    
    func isBetActive(_ type: BetType) -> Bool {
        return activeBets.contains(where: { $0.type == type })
    }
    
    func betTypeFrom(sectionIndex index: Int) -> BetType {
        switch index {
        case 0:
            return .first12
        case 1:
            return .second12
        case 2:
            return .third12
        default:
            return .number(-1)  // не должно случиться
        }
    }
    
    func betTypeFrom(lowerSectionIndex index: Int) -> BetType {
        switch index {
        case 0:
            return .range1_18
        case 1:
            return .even
        case 2:
            return .red
        case 3:
            return .black
        case 4:
            return .odd
        case 5:
            return .range19_36
        default:
            return .number(-1)
        }
    }
}
