//
//  SettingsView.swift
//  test_roulette
//
//  Created by Mac Pro on 19.08.2023.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct SettingsView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @Binding var path: NavigationPath
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {
                authModel.signOut()
                path.append(NavigationObject(flow: .auth(.auth)))
                
            }) {
                Text("Log out")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                authModel.deleteAccount { error in
                    if let error = error {
                        print("Failed to delete account: \(error.localizedDescription)")
                    } else {
                        print("Account deleted successfully")
                    }
                }
                path.append(NavigationObject(flow: .auth(.auth)))
                
            }) {
                Text("Delete Account")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                settingsViewModel.rateApp()
                print("Rate app tapped")
            }) {
                Text("Rate app")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                settingsViewModel.shareApp { _ in
                    showingShareSheet = true
                }
                print("Share App tapped")
            }) {
                Text("Share App")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showingShareSheet) {
                ActivityViewController(activityItems: [URL(string: "https://www.traffbraza.com/")!], applicationActivities: nil)
            }
        }
        .padding()
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(path: .constant(NavigationPath())).environmentObject(SettingsViewModel())
    }
}
