//
//  AuthViewModel.swift
//  test_roulette
//
//  Created by Mac Pro on 19.08.2023.
//



import SwiftUI
import FirebaseAuth
import FirebaseFirestore

final class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    private var db = Firestore.firestore()
    
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
            
            if let uuid = authResult?.user.uid {
                print("Anonymously signed in with User ID: \(uuid)")
                
                self.createUserInFirestore(uuid: uuid) { error in
                    if let error = error {
                        print("Error creating user in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Successfully created user in Firestore")
                    }
                }
            }
        }
    }
    
    
    func signOut() {
        do { try Auth.auth().signOut() }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError) }
    }
    
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "AuthError", code: -1, userInfo: ["description": "No current user found"]))
            return
        }
        
        let uuid = currentUser.uid
        currentUser.delete { [weak self] error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            self?.deleteUserDataFromFirestore(uuid: uuid) { error in
                if let error = error {
                    print("Error deleting user data from Firestore: \(error.localizedDescription)")
                }
                completion(error)
            }
        }
    }
    
    func deleteUserDataFromFirestore(uuid: String, completion: @escaping (Error?) -> Void) {
        db.collection("Users").document(uuid).delete() { error in
            completion(error)
        }
    }

    
    func createUserInFirestore(uuid: String, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "uuid": uuid,
            "winRate": 0,
            "coins": 2000
        ]
        
        db.collection("Users").document(uuid).setData(userData) { error in
            completion(error)
        }
    }
    
    func getUserDataFromFirestore(uuid: String, completion: @escaping (AppUser?, Error?) -> Void) {
        db.collection("Users").document(uuid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = snapshot?.data(), let appUser = AppUser(data: data) {
                completion(appUser, nil)
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: ["description": "No user data found"]))
            }
        }
    }
    
    func fetchUserData() {
        if let uuid = Auth.auth().currentUser?.uid {
            getUserDataFromFirestore(uuid: uuid) { appUser, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                } else {
                    print("Fetched user data: \(String(describing: appUser))")
                }
            }
        }
    }
    
    
    
}
