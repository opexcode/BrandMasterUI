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
            
            Settings()
                .tabItem({
                    
                    Image(systemName: "gearshape")
                    Text("Настройки")
                })
            
            InfoShell()
                
                .tabItem({
                    
                    Image(systemName: "bookmark")
                    Text("Инфо")
                })
                
                // Скрываем клавиатуру
//                .gesture(DragGesture().onChanged { _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
//                .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
    }
}

let dict = [
    "командир звена",
    "газодымозащитник",
    "постовой на посту безопасности",
    
    "помощник НК",
    "командир отделения",
    "пожарный",
    "водитель ПА",
    
    "дежурный по подразделению",
    "дневальный по гаражу",
    "дневальный по помещениям",
    "постовой у фасада",
    
    "обслуживание сизод",
    "правила работы в СИЗОД",
    "звено ГДЗС",
    "пост безопасности",
    
    "минимум оснащения",
    "оснащение звена"
    
]

struct InfoShell: View {
    
    @State var filteredItems = dict
    @State var showSearch = false
    
    var body: some View {
        CustomNavigationView(view: Info(filteredItems: $filteredItems, showSearch: $showSearch), onSearch: { txt in
            
            // filtering Data...
            if txt != "" {
                self.showSearch = true
                self.filteredItems = dict.filter{$0.lowercased().contains(txt.lowercased())}
                
                
            }
            else {
                self.showSearch = false
                self.filteredItems = dict
            }
            
            
        }, onCancel: {
            // Do your code when search and canceled...
            self.showSearch = false
            self.filteredItems = dict
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}


