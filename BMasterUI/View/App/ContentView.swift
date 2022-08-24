//
//  ContentView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 05.09.2021.
//

import SwiftUI

struct ContentView: View {
   
//   init() {
//      let coloredAppearance = UINavigationBarAppearance()
//      coloredAppearance.configureWithOpaqueBackground()
////      coloredAppearance.configureWithTransparentBackground()  // прозрачный
////      coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
////      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
//
//      UINavigationBar.appearance().standardAppearance = coloredAppearance
//      UINavigationBar.appearance().compactAppearance = coloredAppearance
//      UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
//
//      UINavigationBar.appearance().tintColor = .systemBlue
//   }
    @StateObject var vm = Parameters()
    
    var body: some View {
        TabView() {
            MainView(vm: vm)
                .tabItem({
                    Image(systemName: "􀙬")
                    Text("Расчеты")
                })
            
            SettingsView(vm: vm)
                .tabItem({
                    Image(systemName: "􀣋")
                    Text("Настройки")
                })
            
            RepositoryView()
                .tabItem({
                    Image(systemName: "􀓕")
                    Text("Инвентарь")
                })
            
            InfoShell()
                .tabItem({
                    Image(systemName: "􀉞")
                    Text("Инфо")
                })
            
        } //: TabView
    }
}

