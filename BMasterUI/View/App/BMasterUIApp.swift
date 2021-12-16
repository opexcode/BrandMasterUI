//
//  BMasterUIApp.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 05.09.2021.
//

import SwiftUI

@main
struct BMasterUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .font(.custom("AppleSDGothicNeo-Semibold", size: 17))
                .environmentObject(Parameters())
        }
    }
}
