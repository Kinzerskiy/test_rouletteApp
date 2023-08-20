//
//  AuthViewModel.swift
//  test_roulette
//
//  Created by Mac Pro on 19.08.2023.
//


import SwiftUI
import FirebaseAuth

final class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                print("User signed in with ID: \(user.uid)")
            } else {
                print("User signed out or not signed in")
            }
            self.user = user
        }
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                return
            }
            print("Anonymously signed in with User ID: \(authResult?.user.uid ?? "Unknown")")
        }
    }
    
    func signOut() {
        do { try Auth.auth().signOut() }
        catch let signOutError as NSError {
        print("Error signing out: %@", signOutError) }
    }
    
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            }
            completion(error)
        }
    }
}
