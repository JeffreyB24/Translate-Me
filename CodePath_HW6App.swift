//
//  CodePath_HW6App.swift
//  CodePath-HW6
//
//  Created by Jeffrey Berdeal on 10/14/25.
//

import SwiftUI

@main
struct CodePath_HW6App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TranslationViewModel())
        }
    }
}


