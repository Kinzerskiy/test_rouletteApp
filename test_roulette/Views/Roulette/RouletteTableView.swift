//
//  RouletteTableView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI

struct RouletteTableView: View {
    
    
    @ObservedObject var model = RouletteViewModel()
    
    
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
            .foregroundColor(model.activeIndex == 0 ? .white : model.color(for: 0))
            .overlay(Text("0").foregroundColor(model.activeIndex == 0 ? .black : .white))
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
                            .overlay(Text("\(number)")
                                .foregroundColor(isHighlighted && !model.spinning ? .green : .white))
                    }
                }
            }
        }
    }
    
    var sideCells: some View {
        VStack(spacing: 1) {
            ForEach(1..<4) { _ in
                Rectangle()
                    .frame(width: 60, height: 40)
                    .foregroundColor(.gray)
                    .overlay(Text("2 - 1").foregroundColor(.white))
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
                            .foregroundColor(.gray)
                            .overlay(
                                Text(sectionText(for: index))
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                HStack(spacing: 1) {
                    ForEach(0..<6) { index in
                        Rectangle()
                            .frame(width: (40 * 12 + 7) / 6, height: 40)
                            .foregroundColor(.gray)
                            .overlay(
                                Text(lowerSectionText(for: index))
                                    .foregroundColor(.white)
                            )
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
        RouletteTableView()
    }
}

