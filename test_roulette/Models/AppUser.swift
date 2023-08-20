//
//  AppUser.swift
//  test_roulette
//
//  Created by Mac Pro on 19.08.2023.
//

import Foundation
import FirebaseAuth

struct AppUser: Hashable, Decodable {
    var winRate: Int
    var coins: Int
    var id: String
    
    init(winRate: Int, coins: Int, id: String) {
        self.winRate = winRate
        self.coins = coins
        self.id = id
    }
}
