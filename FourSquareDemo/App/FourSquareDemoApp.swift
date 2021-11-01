//
//  FourSquareDemoApp.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import SwiftUI

@main
struct FourSquareDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AppMainView().onAppear {
                LocationManager.shared.setupManager()
            }
        }
    }
}
