//
//  AppLogoResizerApp.swift
//  Shared
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI
import RevenueCat

@main
struct AppLogoResizerApp: App {
    @StateObject var viewModel = LogoViewModel()
    
    init(){
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "gcfugoRFrnhgPNNUyysDahMjUILDRicI")
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
