//
//  PurchasesServices.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 01.10.21.
//

import Foundation
import RevenueCat
import SwiftUI
class PurchasesService: ObservableObject{
    
    @Published var allPackages = [Package]()
    
    var emoji = [
        "Cookie_Tip": "🍪",
        "Coffee_Tip": "☕️"
    ]
    func getProducts(){
        DispatchQueue.main.async {
            Purchases.shared.offerings { (offerings, error) in
                if let packages = offerings?.current?.availablePackages {
                    for package in packages {
                        withAnimation {
                            self.allPackages.append(package)
                        }
                    }
                }
            }
        }
    }
    
    func purchasesProduct(package: Package, completion: @escaping (_ success: Bool) -> Void){
        Purchases.shared.purchase(package: package) { transcaction, purchaserInfo, error, userCancelled in
            completion(!userCancelled)
        }
    }
}
