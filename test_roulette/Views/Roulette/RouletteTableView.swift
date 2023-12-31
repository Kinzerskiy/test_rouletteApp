//
//  RouletteTableView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct RouletteTableView: View {

    @ObservedObject var model: RouletteViewModel
    @ObservedObject var authViewModel: AuthViewModel
   


    
    var betTypeCompletion: (BetType) -> ()
   
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
            
            .overlay(Text("0").foregroundColor(model.activeIndex == 0 ? .black : .white))
            .foregroundColor(model.color(for: 0))
            .opacity(model.playerSelectedNumber == 0 ? 0.5 : 1)
            .onTapGesture {
                self.betTypeCompletion(.number(0))
                model.selectedBetType = nil
                   if model.playerSelectedNumber == 0 {
                       model.playerSelectedNumber = nil
                   } else {
                       model.playerSelectedNumber = 0
                   }
            }
    }
    
    var numbersBoard: some View {
           VStack(spacing: 1) {
               ForEach((1..<4).reversed(), id: \.self) { rowIndex in
                   HStack(spacing: 1) {
                       ForEach(1..<13) { columnIndex in
                           let number = (columnIndex - 1) * 3 + rowIndex
                           
                           Rectangle()
                               .frame(width: 40, height: 40)
                               .foregroundColor(model.color(for: number))
                               .opacity(
                                   (model.highlightedIndex != nil && model.wheelOrder[model.highlightedIndex!] == number) ? 0.5 :
                                   (model.playerSelectedNumber == number || model.wheelResultNumber == number) ? 0.5 : 1.0
                               )
                               .overlay(Text("\(number)")).foregroundColor(.white)
                               .onTapGesture {
                                   model.selectedBetType = .number(number)
                                   self.betTypeCompletion(.number(number))
                                   
                                   if model.playerSelectedNumber == number || model.wheelResultNumber == number {
                                       model.playerSelectedNumber = nil
                                       model.isNumberSelected = false
                                   } else {
                                       model.playerSelectedNumber = number
                                       model.isNumberSelected = true
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
                        model.playerSelectedNumber = nil
                        model.selectedBetType = nil
                        self.betTypeCompletion([.firstLine, .secondLine, .thirdLine][index - 1] )

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
                                self.betTypeCompletion([.firstThird, .secondThird, .thirdThird][index])
                                model.playerSelectedNumber = nil
                                model.selectedBetType = nil
                              
                                model.selectBetType([.firstThird, .secondThird, .thirdThird][index])
                            }
                    }
                }
                
                HStack(spacing: 1) {
                    ForEach(0..<6) { index in
                        Rectangle()
                            .frame(width: (40 * 12 + 7) / 6, height: 40)
                            
                            .foregroundColor(model.selectedBetType == [.oneEighteen, .even, .red, .black, .odd, .nineghtingThirtySix][index] ? .red : .gray)
                            .overlay(
                                Text(lowerSectionText(for: index))
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                self.betTypeCompletion([.oneEighteen, .even, .red, .black, .odd, .nineghtingThirtySix][index])
                                model.playerSelectedNumber = nil
                                model.selectedBetType = nil
                            
                                model.selectBetType([.oneEighteen, .even, .red, .black, .odd, .nineghtingThirtySix][index])
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
        RouletteTableView(model: RouletteViewModel(), authViewModel: AuthViewModel(), betTypeCompletion: {_ in})
    }
}

