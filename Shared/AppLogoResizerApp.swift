//
//  AppLogoResizerApp.swift
//  Shared
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI

@main
struct AppLogoResizerApp: App {
    @StateObject var viewModel = LogoViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
