//
//  PurchasesServices.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 01.10.21.
//

import Foundation
import RevenueCat

class PurchasesService: ObservableObject{
    
    @Published var allPackages = [Package]()
    
    var emoji = [
        "Cookie Tip": "🍪",
        "Coffe Tip": "☕️"
    ]
    func getProducts(){
        DispatchQueue.main.async {
            Purchases.shared.offerings { (offerings, error) in
                if let packages = offerings?.current?.availablePackages {
                    for package in packages {
                        self.allPackages.append(package)
                    }
                }
            }
        }
    }
    
    func purchasesProduct(package: Package, completion: @escaping (_ success: Bool) -> Void){
        Purchases.shared.purchase(package: package) { transcaction, purchaserInfo, error, userCancelled in
            print(transcaction?.transactionDate, purchaserInfo?.nonSubscriptionTransactions, purchaserInfo?.firstSeen)
            completion(!userCancelled)
        }
    }
}
