//
//  AppLogoResizerApp.swift
//  Shared
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI

@main
struct AppLogoResizerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
