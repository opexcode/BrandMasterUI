//
//  Info.swift
//  MasterUI
//
//  Created by Алексей on 18.11.2020.
//

import SwiftUI

struct Info: View {
    @State private var text = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search ...", text: $text)
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                                .onTapGesture {
//                                    self.isEditing = true
                                }
                List {
                    Section(header: Text("info")) {
                        NavigationLink(destination: Service()) {
                            Image(systemName: "star.fill")
                            Text("Примечания к формулам")
                        }
                        
                        NavigationLink(destination: Instructions()) {
                            Image(systemName: "folder.fill")
                            Text("Обязаности")
                        }
                        
                        NavigationLink(destination: Service()) {
                            Image(systemName: "folder.fill")
                            Text("ГДЗС")
                        }
                        
                        NavigationLink(destination: Devices()) {
                            Image(systemName: "folder.fill")
                            Text("СИЗОД")
                        }
                        
                        NavigationLink(destination: Service()) {
                            Image(systemName: "folder.fill")
                            Text("РТП")
                        }
                        
                    }
                    
                    Section(header: Text("").frame(height: 50)) {
                        NavigationLink(destination: Instructions()) {
                            Image(systemName: "applelogo")
                            Text("Оценить БрандМастер")
                            
                        }
                        
                        NavigationLink(destination: Instructions()) {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("БрандМастер в VK")
                        }
                        
                        NavigationLink(destination: Instructions()) {
                            Image(systemName: "at.badge.plus")
                            Text("Написать разработчику")
                        }
                        
                        NavigationLink(destination: Instructions()) {
                            Image(systemName: "lock.fill")
                            Text("Политика конфеденциальности")
                        }
                    }
                }
            }
            
//            VStack {
//                Text("БрандМастер - ГДЗС")
//                Text("version 1.0")
//            }
            .navigationBarTitle("Информация")
        }
    }
}


struct Instructions: View {
    private var service = ["Командир звена", "Газодымозащитник", "Постовой", "При использовании ДАСК", "При использовании ДАСК"]
    
    private var funcional = ["Помощник НК", "Командир отделения", "Пожарный", "Водитель ПА"]
    
    private var inner = ["Дежурный по подразделению", "Дневальный по гаражу", "Дневальный по помещениям", "Постовой у фасада"]
    
    var body: some View {
        List {
            Section(header: Text("ГДЗС").frame(height: 50)) {
                ForEach(0..<service.count) {
                    Text("\(service[$0])")
                }
            }
            
            
            Section(header: Text("Функциональные").frame(height: 50)) {
                ForEach(0..<funcional.count) {
                    Text("\(funcional[$0])")
                }
            }
            
            Section(header: Text("Внутренний наряд").frame(height: 50)) {
                ForEach(0..<inner.count) {
                    Text("\(inner[$0])")
                }
            }
        }
    }
}

struct Service: View {
    private var service = ["Обслуживание СИЗОД", "Правила работы в СИЗОД", "Звено и ПБ", "Минимум оснащения"]
    
    var body: some View {
        List {
            ForEach(0..<service.count) {
                Text("\(service[$0])")
            }
        }
    }
}

struct Devices: View {
    var body: some View {
        Text("СИЗОД")
    }
}

struct DisplayText: View {
    var body: some View {
        Text("Text")
    }
}
