//
//  MainNavigationView.swift
//  test_roulette
//
//  Created by Mac Pro on 20.08.2023.
//

import SwiftUI

struct MainNavigationView: View {
    
    
    @Binding var path: NavigationPath
    
    var body: some View {
        TabView{
            CombinedRouletteView(path: $path, authViewModel: AuthViewModel(), betViewModel: BetViewModel(authViewModel: AuthViewModel()), completion: {_ in})
                .tabItem {
                    Label("Game", systemImage: "flag.2.crossed")
                }
            
            SettingsView(path: $path)
                .environmentObject(SettingsViewModel())
                .environmentObject(AuthViewModel())
                .tabItem {
                    Label("Settings", systemImage: "rectangle.inset.filled.and.person.filled")
                }
        }
        
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView(path: .constant(NavigationPath()))
    }
}
