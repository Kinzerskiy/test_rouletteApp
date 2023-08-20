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
                CombinedRouletteView(path: $path)
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }

                SettingsView(path: $path)
                                .environmentObject(SettingsViewModel())
                                .environmentObject(AuthViewModel())
                    .tabItem {
                        Label("Order", systemImage: "square.and.pencil")
                    }
            }
            
        }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView(path: .constant(NavigationPath()))
    }
}
