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
    let amount: Int
    let betType: BetType
}

class BetViewModel: ObservableObject {
    
    @Published var currentBet: Bet?
    @Published var betAmount: Int?
    
    static let shared = BetViewModel()

    
    func bet(amount: Int, betType: BetType) {
        currentBet = .init(amount: amount, betType: betType)
        print("Bet placed: \(amount) on \(betType)")
    }
    
    func resetBet() {
        currentBet = nil
    }
    
    func calculateResult(result: Int) -> Int {
        defer {
            resetBet()
        }
        guard let currentBet = currentBet else { return 0 }
        switch currentBet.betType {
        case .number(let number):
            if number == result {
                return currentBet.amount * 35
            }
        case .odd:
            if result % 2 != 0 {
                return currentBet.amount * 2
            }
        case .even:
            if result % 2 == 0{
                return currentBet.amount * 2
            }
        case .red:
            if [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36].contains(result) {
                return currentBet.amount * 2
            }
        case .black:
            if [2, 4, 6, 8, 11, 10, 13, 15,17, 20, 24, 22, 26, 29, 28, 31, 33, 35].contains(result) {
                return currentBet.amount * 2
            }
        case .firstThird:
            if [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].contains(result) {
                return currentBet.amount * 3
            }
        case .secondThird:
            if [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24].contains(result) {
                return currentBet.amount * 3
            }
        case .thirdThird:
            if [25,26,27,28,29,30,31,32,33,34,35,36].contains(result) {
                return currentBet.amount * 3
            }
        case .oneEighteen:
            if [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].contains(result) {
                return currentBet.amount * 2
            }
        case .nineghtingThirtySix:
            if [19, 20, 21, 22, 23, 24,25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36].contains(result) {
                return currentBet.amount * 2
            }
        case .firstLine:
            if [1,3,7,10,13,16,19,22,25,28,31,34].contains(result) {
                return currentBet.amount * 3
            }
        case .secondLine:
            if [2,5,8,11,14,17,20,23,26,29,32,35].contains(result) {
                return currentBet.amount * 3
            }
        case .thirdLine:
            if [3,6,9,12,15,18,21,24,27,30,33,36].contains(result) {
                return currentBet.amount * 3
            }
        }
        return 0
    }
}
