//
//  ClipHistApp.swift
//  ClipHist
//
//  Created by Jhamir Francisco Piminchumo on 21/12/21.
//

import SwiftUI

@main
struct ClipHistApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    getPermissions()
                }
        }
    }
    
    func getPermissions() {
        AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        )
    }
}
