//
//  RouletteTableView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct RouletteTableView: View {

    @ObservedObject var model = RouletteViewModel(betViewModel: BetViewModel(), authViewModel: AuthViewModel())
    @ObservedObject var authViewModel: AuthViewModel
  
    var body: some View {
        VStack(spacing: 1) {
            mainBoard
            horizontalCells
        }
    }
    
    var mainBoard: some View {
        HStack(spacing: 1) {
            zeroCell
            numbersBoard
            sideCells
        }
    }
    
    var zeroCell: some View {
        Rectangle()
            .frame(width: 40, height: 122)
            .foregroundColor(model.selectedBetType == .number(0) ? .gray : model.color(for: 0))
            .overlay(Text("0").foregroundColor(model.activeIndex == 0 ? .black : .white))
            .onTapGesture {
                model.betViewModel.resetBet()
                model.selectedBetType = nil
                model.selectBetType(.number(0))
            }
    }
    
    var numbersBoard: some View {
        VStack(spacing: 1) {
            ForEach((1..<4).reversed(), id: \.self) { rowIndex in
                HStack(spacing: 1) {
                    ForEach(1..<13) { columnIndex in
                        let number = (columnIndex - 1) * 3 + rowIndex
                        let isHighlighted = model.activeIndex == number
                        
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(model.color(for: number))
                            .opacity(model.selectedNumber == number ? 0.5 : 1.0)
                            .overlay(Text("\(number)")
                                .foregroundColor(isHighlighted && !model.spinning ? .green : .white))
                        
                            
                            .onTapGesture {
                                model.betViewModel.resetBet()
                                model.selectedBetType = nil
                                if model.selectedNumber == number {
                                     model.selectedNumber = nil
                                 } else {
                                     
                                     model.isNumberSelected = true
                                     model.selectedNumber = number
                                 }
                            }
                    }
                }
            }
        }
    }
    
    var sideCells: some View {
        VStack(spacing: 1) {
            ForEach(1..<4) { index in
                Rectangle()
                    .frame(width: 60, height: 40)
                    .foregroundColor(model.selectedBetType == [.firstLine, .secondLine, .thirdLine][index - 1] ? .red : .gray)
                    .overlay(Text("2 - 1").foregroundColor(.white))
                    .onTapGesture {
                        model.selectedNumber = nil
                        model.selectedBetType = nil
                        model.betViewModel.resetBet()
                        
                        model.selectBetType([.firstLine, .secondLine, .thirdLine][index - 1])
                    }
            }
        }
    }
    
    var horizontalCells: some View {
        HStack(spacing: 1) {
            Spacer()
                .frame(width: 20)
            
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    ForEach(0..<3) { index in
                        Rectangle()
                            .frame(width: (40 * 12 + 10) / 3, height: 40)
                            .foregroundColor(model.selectedBetType == [.firstThird, .secondThird, .thirdThird][index] ? .red : .gray)
                            .overlay(
                                Text(sectionText(for: index))
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                model.betViewModel.resetBet()
                                model.selectedNumber = nil
                                model.selectedBetType = nil
                                model.selectBetType([.firstThird, .secondThird, .thirdThird][index])
                            }
                    }
                }
                
                HStack(spacing: 1) {
                    ForEach(0..<6) { index in
                        Rectangle()
                            .frame(width: (40 * 12 + 7) / 6, height: 40)
                            
                            .foregroundColor(model.selectedBetType == [.oneEighteen, .nineghtingThirtySix, .odd, .even, .red, .black][index] ? .red : .gray)
                            .overlay(
                                Text(lowerSectionText(for: index))
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                model.betViewModel.resetBet()
                                model.selectedNumber = nil
                                model.selectedBetType = nil
                                model.selectBetType([.oneEighteen, .nineghtingThirtySix, .odd, .even, .red, .black][index])
                            }
                    }
                }
            }
            
            Spacer()
                .frame(width: 40)
        }
    }
    
    
    func sectionText(for index: Int) -> String {
        switch index {
        case 0:
            return "1st 12"
        case 1:
            return "2nd 12"
        case 2:
            return "3rd 12"
        default:
            return ""
        }
    }
    
    
    func lowerSectionText(for index: Int) -> String {
        switch index {
        case 0:
            return "1-18"
        case 1:
            return "Even"
        case 2:
            return "Red"
        case 3:
            return "Black"
        case 4:
            return "Odd"
        case 5:
            return "19-36"
        default:
            return ""
        }
    }
}


struct RouletteView_Previews: PreviewProvider {
    static var previews: some View {
        RouletteTableView(authViewModel: AuthViewModel())
    }
}

