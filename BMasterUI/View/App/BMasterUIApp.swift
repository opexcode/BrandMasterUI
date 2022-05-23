//
//  BMasterUIApp.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 05.09.2021.
//

import SwiftUI

@main
struct BMasterUIApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .font(.custom("AppleSDGothicNeo-Semibold", size: 17))
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    try? dataController.container.viewContext.save()
                }
        }
    }
}
