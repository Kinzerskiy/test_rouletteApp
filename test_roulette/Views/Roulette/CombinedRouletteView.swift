//
//  CombinedRouletteView.swift
//  test_roulette
//
//  Created by Mac Pro on 18.08.2023.
//

import SwiftUI


struct CombinedRouletteView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var betViewModel: BetViewModel
    @ObservedObject var model: RouletteViewModel
    
    @Binding var path: NavigationPath
    
    @State private var winnings: Int = 0
    @State private var showAlert: Bool = false
    @State private var alertComment: String = ""
    
    init(path: Binding<NavigationPath>) {
        
        _path = path
        self.authViewModel = AuthViewModel()
        self.betViewModel = BetViewModel()
        self.model = RouletteViewModel()
    }
    
    
    func procced(with value: Int) {
        
        let group = DispatchGroup()
            
        group.enter()
        
        let result = self.betViewModel.calculateResult(result: value)
        
            DispatchQueue.global().async {
                
                self.fetchWinnings(winnings: result)
                group.leave()
            }
            
            group.notify(queue: .main) {
                ChatGPTService.shared.fetchComment(for: winnings) { comment in
                    DispatchQueue.main.async {
                        self.alertComment = "\(comment) Вы \(winnings > 0 ? "выиграли" : "проиграли") \(abs(winnings)) coins."
                        self.showAlert = true
                    }
                }
            }
    }
    
    func fetchWinnings(winnings: Int) {
       
        if let user = authViewModel.appUser {
            var mutableUser = user
            mutableUser.coins += winnings
            authViewModel.appUser = mutableUser
            authViewModel.updateUserData(user: mutableUser)
            
      
        }
    }
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                
                VStack {
                    RouletteTableView(model: self.model, authViewModel: self.authViewModel, betTypeCompletion: { betType in
                        self.betViewModel.updateBetType(betType: betType)
                    })
                    
                }
                .position(x: geometry.size.width * 0.5, y: geometry.size.height / 1.4)
                
                
                RouletteWheelView(model: self.model)
                    .frame(width: geometry.size.height * 0.35)
                    .position(x: geometry.size.width * 0.15, y: geometry.size.height / 5.2)
                
                HStack(spacing: 20) {
                    
                    VStack {
                        Spacer()
                        
                        Spacer()
                        BetView(authViewModel: authViewModel, amountCompletion: { amount in
                            self.betViewModel.updateAmount(amount: amount)
                        })
                        .frame(width: 240, height: 200)
                    }
                    
                    
                
                VStack {
                    Spacer()
                    Button(action: {
                        self.model.startSpinning { result in
                            self.procced(with: result)
                        }
                    }) {
                        Text("Start")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                .frame(width: 200, height: 165)
                    
               
                    
            }
                
                .position(x: geometry.size.width * 0.6, y: geometry.size.height / 35 - 25)
                
               
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Результат игры"), message: Text(alertComment), dismissButton: .default(Text("OK")))
            }
        }
    }
}



struct CombinedRouletteView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedRouletteView(path: .constant(NavigationPath()))
    }
}
