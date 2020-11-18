//
//  ContentView.swift
//  MasterUI
//
//  Created by Алексей on 14.11.2020.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView() {
            Main()
                .tabItem({
                    
                    Image(systemName: "flame")
                    
                    Text("Расчеты")
                })
                .tag(0)
            
            Settings()
                .tabItem({
                    
                    Image(systemName: "gearshape")
                    
                    Text("Настройки")
                })
                .tag(0)
            
            Info()
                .tabItem({
                    
                    Image(systemName: "bookmark")
                    
                    Text("Инфо")
                })
                .tag(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}


