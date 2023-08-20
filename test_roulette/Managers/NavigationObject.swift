//
//  NavigationObject.swift
//  Pods
//
//  Created by Mac Pro on 20.08.2023.
//

import Foundation
import SwiftUI

struct NavigationObject: Hashable {
    
    enum Screen: Hashable {
        case auth, main
    }
    
    enum Flow: Hashable {
        case auth(Screen), main(Screen)
    }
    
    let flow: Flow

    @ViewBuilder func configureNextScreen(with path: Binding<NavigationPath>) -> some View {
        switch flow {
        case .auth(let screen):
            configure(screen: screen, with: path)
        case .main(let screen):
            configure(screen: screen, with: path)
        }
    }
    
    @ViewBuilder private func configure(screen: Screen, with path: Binding<NavigationPath>) -> some View {
        
        switch screen {
        case .main:
            MainNavigationView(path: path)
                .navigationBarBackButtonHidden(true)
        case .auth:
            AuthView(path: path)
                .navigationBarBackButtonHidden(true)
                .environmentObject(AuthViewModel())
        }
    }
    
    static func == (lhs: NavigationObject, rhs: NavigationObject) -> Bool {
        lhs.flow == rhs.flow
    }
}
