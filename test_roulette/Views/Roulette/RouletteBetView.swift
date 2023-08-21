//
//  RouletteBetView.swift
//  test_roulette
//
//  Created by Mac Pro on 20.08.2023.
//
//
//import SwiftUI
//
//struct RouletteBetView: View  {
//
//    @ObservedObject var bettingManager: BettingManager
//
//    var body: some View {
//        VStack {
//            TextField("Enter bet amount", value: $bettingManager.betAmount, formatter: NumberFormatter())
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.decimalPad)
//
//
//            HStack {
//                Button(action: {
//                    bettingManager.placeBet(on: .red, amount: bettingManager.betAmount)
//                }) {
//                    Text("Bet Red")
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//
//                Button(action: {
//                    bettingManager.placeBet(type: .black, amount: bettingManager.betAmount)
//                }) {
//                    Text("Bet Black")
//                        .padding()
//                        .background(Color.black)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//        }
//    }
//}
//
//    struct RouletteBetView_Previews: PreviewProvider {
//        static var previews: some View {
//            RouletteBetView(bettingManager: BettingManager())
//        }
//    }
