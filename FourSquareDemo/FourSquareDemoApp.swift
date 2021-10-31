//
//  FourSquareDemoApp.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import SwiftUI

@main
struct FourSquareDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
