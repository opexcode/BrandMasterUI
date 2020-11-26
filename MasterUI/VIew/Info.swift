//
//  Info.swift
//  MasterUI
//
//  Created by Алексей on 18.11.2020.
//

import SwiftUI


struct Info: View {
    
    @State private var searchText = ""
    @ObservedObject var fetchFrom = JSONParser()
    
    var array = ["минимум", "постового", "командир", "пожарный", "водитель", "гдзс", "сизод", "оснащение", "обслуживание"]
    
    var text = "text"
    
    var dict = ["минимум": DisplayText(text: "text")]
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                
                TextField("Поиск...", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                List {
                    
                    if searchText != "" {
                        
                        ForEach(array.filter{searchText == "" || $0.hasPrefix(searchText)}, id:\.self) { searchText in
                            NavigationLink(destination: DisplayText(text: searchText)) {
                                Text(searchText)
                            }
                        }
                    }
                }
                
                VStack {
                NavigationLink(destination: Service()) {
                    Image(systemName: "star.fill")
                    Text("Примечания к формулам")
                }.padding(5)
                    Divider()
                
                NavigationLink(destination: Instructions()) {
                    Image(systemName: "folder")
                    Text("Обязаности")
                }.padding(5)
                    Divider()
                
                NavigationLink(destination: Service()) {
                    Image(systemName: "folder")
                    Text("ГДЗС")
                }.padding(5)
                    Divider()
                
                NavigationLink(destination: Devices()) {
                    Image(systemName: "folder")
                    Text("СИЗОД")
                }.padding(5)
                    Divider()
                
                NavigationLink(destination: Service()) {
                    Image(systemName: "folder")
                    Text("РТП")
                }.padding(5)
                    Divider()
            }
                
                
                
            }.navigationBarTitle("Информация")
            // Скрываем клавиатуру
            .gesture(DragGesture().onChanged { _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

// Обязанности
struct Instructions: View {
    
    @ObservedObject var fetchFrom = JSONParser()
    
    private var service = ["Командир звена", "Газодымозащитник", "Постовой", "При использовании ДАСК", "При использовании ДАСК"]
    private var functional = ["Помощник НК", "Командир отделения", "Пожарный", "Водитель ПА"]
    private var inner = ["Дежурный по подразделению", "Дневальный по гаражу", "Дневальный по помещениям", "Постовой у фасада"]
    
    var body: some View {
        
        List {
            Section(header: Text("ГДЗС").frame(height: 50)) {
                
                ForEach(0..<service.count) { i in
                    NavigationLink(destination: DisplayText(text: fetchFrom.json[0].service[i])) {
                        Image(systemName: "doc.text")
                        Text(service[i])
                    }
                }
            }
            
            Section(header: Text("Функциональные").frame(height: 50)) {
                
                ForEach(0..<functional.count) { i in
                    NavigationLink(destination: DisplayText(text: fetchFrom.json[0].functional[i])) {
                        Image(systemName: "doc.text")
                        Text(functional[i])
                    }
                }
            }
            
            Section(header: Text("Внутренний наряд").frame(height: 50)) {
                
                ForEach(0..<inner.count) { i in
                    NavigationLink(destination: DisplayText(text: fetchFrom.json[0].inner[i])) {
                        Image(systemName: "doc.text")
                        Text(inner[i])
                    }
                }
            }
        }
    }
}


// ГДЗС
struct Service: View {
    
    @ObservedObject var fetchFrom = JSONParser()
    
    private var service = ["Обслуживание СИЗОД", "Правила работы в СИЗОД", "Звено и ПБ", "Минимум оснащения"]
    
    var body: some View {
        List {
            Section {
                ForEach(0..<service.count) { i in
                    NavigationLink(destination: DisplayText(text: fetchFrom.json[0].maintenance[i])) {
                        Image(systemName: "doc.text")
                        Text(service[i])
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("ГДЗС")
    }
}


// СИЗОД
struct Devices: View {
    
    let devices = ["АП Омега", "ПТС Базис", "ПТС Профи М/МП", "AirGO MSA", "Drager PSS 3000/5000"]
    var body: some View {
        
        List(devices, id: \.self) { device in
            
            NavigationLink(destination: DeviceFeatures()) {
                Text(device)
                    .lineLimit(1)
                
                Spacer()
                
                Link("PDF", destination: URL(string: "https://alekseyorehov.github.io/BrandMaster/")!)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("СИЗОД")
    }
}


// РТП

struct DisplayText: View {
    var text: String
    
    @State private var fontSize = 20
    
    var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
        .toolbar {
            Stepper("", value: $fontSize, in: 14...25)
            //				.disabled(fireStatus == 0)
        }
    }
}


struct DeviceFeatures: View {
    var body: some View {
        Text("SomeText")
    }
}
