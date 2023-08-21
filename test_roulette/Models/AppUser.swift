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
    var uuid: String
    
    init(winRate: Int, coins: Int, uuid: String) {
        self.winRate = winRate
        self.coins = coins
        self.uuid = uuid
    }
}

extension AppUser {
    init?(data: [String: Any]) {
        guard let winRate = data["winRate"] as? Int,
              let coins = data["coins"] as? Int,
              let uuid = data["uuid"] as? String else {
            return nil
        }
        
        self.init(winRate: winRate, coins: coins, uuid: uuid)
    }
}
