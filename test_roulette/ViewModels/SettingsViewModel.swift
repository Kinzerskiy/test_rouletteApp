//
//  SettingsViewModel.swift
//  test_roulette
//
//  Created by Mac Pro on 19.08.2023.
//

import Foundation
import StoreKit

final class SettingsViewModel: ObservableObject {
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
    func shareApp(completion: @escaping (UIActivityViewController) -> Void) {
        let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        completion(activityViewController)
    }
}
