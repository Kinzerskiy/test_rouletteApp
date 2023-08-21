//
//  test_rouletteApp.swift
//  test_roulette
//
//  Created by Mac Pro on 17.08.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

@main
struct test_rouletteApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                if Auth.auth().currentUser == nil {
                    AuthView(path: $path)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(AuthViewModel())
                        .navigationDestination(for: NavigationObject.self) { navigationObject in
                            navigationObject.configureNextScreen(with: $path)
                        }
                } else {
                    MainNavigationView(path: $path)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: NavigationObject.self) { navigationObject in
                            navigationObject.configureNextScreen(with: $path)
                        }
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
