//
//  Info.swift
//  MasterUI
//
//  Created by Алексей on 18.11.2020.
//

import SwiftUI


struct Info: View {
    
    var search = SearchTest()
    @Binding var filteredItems: [String]
    @Binding var showSearch: Bool
    
    var body: some View {
        
        if showSearch {
            // Показываем поисковые запросы...
            List {
                ForEach(filteredItems, id: \.self) { item in
                    NavigationLink(destination: Display(text: search.getContent(by: item))) {
                        Image(systemName: "magnifyingglass")
                        Text(item)
                    }
                }
            }
            // .listStyle(InsetListStyle())
            
        } else {
            // показываем стандартное меню...
            List {
                Section {
                    NavigationLink(destination: Service()) {
                        Image(systemName: "star.fill")
                        Text("Примечания к формулам")
                    }
                    
                    NavigationLink(destination: Instructions()) {
                        Image(systemName: "folder")
                        Text("Обязаности")
                    }
                    
                    NavigationLink(destination: Service()) {
                        Image(systemName: "folder")
                        Text("ГДЗС")
                    }
                    
                    NavigationLink(destination: Devices()) {
                        Image(systemName: "folder")
                        Text("СИЗОД")
                    }
                    
                    NavigationLink(destination: Service()) {
                        Image(systemName: "folder")
                        Text("РТП")
                    }
                    
                }
                
                Section(header: Text(""), footer: Gain()) {
                    
                    HStack {
                        Image(systemName: "applelogo")
                        Link("Оценить БрандМастер", destination: URL(string: "https://apps.apple.com/ru/app/id1508823670")!)
                    }
                    
                    HStack {
                        Image(systemName: "person.2.circle")
                        Link("БрандМастер в VK", destination: URL(string: "https://vk.com/brmeister")!)
                    }
                    
                    HStack {
                        Image(systemName: "at")
                        Link("Написать разработчику", destination: URL(string: "mailto:bmasterfire@gmail.com")!)
                    }
                    
                    HStack {
                        Image(systemName: "lock.fill")
                        Link("Политика конфеденциальности", destination: URL(string: "https://alekseyorehov.github.io/BrandMaster/")!)
                    }
                }
            }
            .listStyle(InsetListStyle())
//            .listStyle(GroupedListStyle())
        }
        
        
        
    }
    
}


struct Gain: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                HStack {
                    Text("БрандМастер - ГДЗС")
                        .padding(.top, 5)
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .cornerRadius(4)
                }
                    
                Text("Версия: 1.0")
                    .padding(.top, 5)
                Text("Alexey Orekhov")
                    .padding(.top, 5)
            }
            Spacer()
        }
        .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
        .padding()
    }
}


struct SearchTest {
    
    var fetchFrom = JSONParser()
    var array = [String]()
    
    init() {
        for searchText in searchDict().keys {
            array.append(searchText)
        }
    }
    
    
    func searchDict() -> [String: String] {
        
        let dict = [
            "командир звена": 		fetchFrom.json[0].service[0],
            "газодымозащитник": 	fetchFrom.json[0].service[1],
            "постовой на посту безопасности": 		fetchFrom.json[0].service[2],
            
            "помощник НК": 			fetchFrom.json[0].functional[0],
            "командир отделения": 	fetchFrom.json[0].functional[1],
            "пожарный": 			fetchFrom.json[0].functional[2],
            "водитель ПА": 			fetchFrom.json[0].functional[3],
            
            "дежурный по подразделению": 	fetchFrom.json[0].inner[0],
            "дневальный по гаражу": 		fetchFrom.json[0].inner[1],
            "дневальный по помещениям": 	fetchFrom.json[0].inner[2],
            "постовой у фасада": 			fetchFrom.json[0].inner[3],
            
            "обслуживание сизод": 		fetchFrom.json[0].maintenance[0],
            "правила работы в СИЗОД": 	fetchFrom.json[0].maintenance[1],
            "звено ГДЗС": 				fetchFrom.json[0].maintenance[2],
            "пост безопасности": 		fetchFrom.json[0].maintenance[2],
            
            "минимум оснащения": 	fetchFrom.json[0].maintenance[3],
            "оснащение звена": 		fetchFrom.json[0].maintenance[3]
            
        ]
        
        return dict
    }
    
    func getContent(by: String) -> String {
        
        if let text = searchDict()[by] {
            return text
        }
        
        return "fail"
    }
    
}


// Обязанности
struct Instructions: View {
    
    @ObservedObject var fetchFrom = JSONParser()
    
    private var service = ["Командир звена",
                           "Газодымозащитник",
                           "Постовой",
                           "При использовании ДАСК",
                           "При использовании ДАСК"]
    
    private var functional = ["Помощник НК",
                              "Командир отделения",
                              "Пожарный",
                              "Водитель ПА"]
    
    private var inner = ["Дежурный по подразделению",
                         "Дневальный по гаражу",
                         "Дневальный по помещениям",
                         "Постовой у фасада"]
    
    var body: some View {
        
        List {
            Section(header: Text("ГДЗС")) {
                
                ForEach(0..<service.count) { i in
                    NavigationLink(destination: Display(text: fetchFrom.json[0].service[i])) {
                        Image(systemName: "doc.text")
                        Text(service[i])
                    }
                }
            }
            
            Section(header: Text("Функциональные")) {
                
                ForEach(0..<functional.count) { i in
                    NavigationLink(destination: Display(text: fetchFrom.json[0].functional[i])) {
                        Image(systemName: "doc.text")
                        Text(functional[i])
                    }
                }
            }
            
            Section(header: Text("Внутренний наряд")) {
                
                ForEach(0..<inner.count) { i in
                    NavigationLink(destination: Display(text: fetchFrom.json[0].inner[i])) {
                        Image(systemName: "doc.text")
                        Text(inner[i])
                    }
                }
            }
        }
        .listStyle(InsetListStyle())
        .navigationBarTitle("Обязанности")
    }
}


// ГДЗС
struct Service: View {
    
    @ObservedObject var fetchFrom = JSONParser()
    
    private var service = ["Обслуживание СИЗОД",
                           "Правила работы в СИЗОД",
                           "Звено и ПБ",
                           "Минимум оснащения"]
    
    var body: some View {
        List {
            Section {
                ForEach(0..<service.count) { i in
                    NavigationLink(destination: Display(text: fetchFrom.json[0].maintenance[i])) {
                        Image(systemName: "doc.text")
                        Text(service[i])
                    }
                }
            }
        }
        .listStyle(InsetListStyle())
        .navigationBarTitle("ГДЗС")
    }
    
}


// СИЗОД
struct Devices: View {
    
    let devices = ["АП Омега",
                   "ПТС Базис",
                   "ПТС Профи М/МП",
                   "AirGO MSA",
                   "Drager PSS 3000/5000"]
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
        .listStyle(InsetListStyle())
        .navigationBarTitle("СИЗОД")
    }
    
}


// РТП

struct Display: View {
    var text: String
    
    @State private var fontSize = 20
    
    var body: some View {
        ScrollView {
            VStack {
                Text(text)
                    .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
