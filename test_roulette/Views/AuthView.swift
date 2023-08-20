//
//  AuthView.swift
//  test_roulette
//
//  Created by Mac Pro on 19.08.2023.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @Binding var path: NavigationPath
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        authModel.signInAnonymously()
                        path.append(NavigationObject(flow: .main(.main)))
                        
                    }) {
                        HStack {
                            Image(systemName: "theatermasks.fill").font(.title)
                            Text("Anonymously").fontWeight(.semibold).font(.callout)
                        }
                    }
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .background(Color.gray)
        }
    }
}



struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
            AuthView(path: .constant(NavigationPath())).environmentObject(AuthViewModel())
    }
}
