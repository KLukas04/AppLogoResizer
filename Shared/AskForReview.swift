//
//  AskForReview.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 07.02.22.
//

import SwiftUI
import Foundation
import StoreKit

struct ReviewCounter: ViewModifier {
    /// Counter of events that would lead to a review being asked for.
    @AppStorage("review.counter") private var reviewCounter = 0
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                reviewCounter += 1
                
                if reviewCounter == 1  || reviewCounter > 5{
                    if reviewCounter != 1{
                        reviewCounter = 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        #if os(macOS)
                        SKStoreReviewController.requestReview()
                        #else
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene{
                            SKStoreReviewController.requestReview(in: scene)
                        }
                        #endif
                    }
                }
            }
    }
}

extension View {
    /// `SKStoreReviewController.requestReview` after 30 `onAppear`-triggering appearances of the view.
    func reviewCounter() -> some View {
        modifier(ReviewCounter())
    }
}
