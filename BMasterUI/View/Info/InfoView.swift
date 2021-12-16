//
//  InfoView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 02.11.2021.
//

import SwiftUI


let dict = [
   "командир звена",
   "газодымозащитник",
   "постовой на посту безопасности",
   
   "помощник НК",
   "пнк",
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
   "оснащение звена",
   "ДАСВ",
   
   "5 решающих направлений",
   "ртп",
   "полномочия РТП",
   "оперативный штаб",
   "разведка"
   
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


struct Info: View {
   var search = Search()
   @Binding var filteredItems: [String]
   @Binding var showSearch: Bool
   
   var body: some View {
      
      return Group {
         if showSearch {
            // Показываем поисковые запросы...
            SearchCompilation
         } else {
            // показываем основное меню...
            InfoList
         }
      }
   }
   
   var SearchCompilation: some View {
      List {
         ForEach(filteredItems, id: \.self) { item in
            NavigationLink(destination: TextViewer(text: search.getContent(by: item))) {
               Image(systemName: "magnifyingglass")
               Text(item)
            }
         }
      }
   }
   
   var InfoList: some View {
      List {
         Section {
            NavigationLink(destination: MarksView()) {
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
               Text("ТТХ СИЗОД")
            }
            
            NavigationLink(destination: Leader()) {
               Image(systemName: "folder")
               Text("РТП")
            }
            
         }
         
         Section(header: Text(""), footer: FooterView()) {
            
            HStack {
               Image(systemName: "person.2.circle")
               Link("БрандМастер в VK", destination: URL(string: "https://vk.com/brmeister")!)
            }
            
            HStack {
               Image(systemName: "applelogo")
               Link("Оценить БрандМастер", destination: URL(string: "https://apps.apple.com/ru/app/id1508823670")!)
            }
            
            
            HStack {
               Image(systemName: "at")
               Link("Написать разработчику", destination: URL(string: "mailto:bmasterfire@gmail.com")!)
            }
            
            //                    HStack {
            //                        Image(systemName: "lock.fill")
            //                        Link("Политика конфеденциальности", destination: URL(string: "https://alekseyorehov.github.io/BrandMaster/")!)
            //                    }
         }
      }
      .listStyle(InsetListStyle())
   }
   
}


// MARK: - Обязанности
struct Instructions: View {
   
   @StateObject var fetchFrom = JSONParser()
   
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
               NavigationLink(destination: TextViewer(text: fetchFrom.json.service[i])) {
                  Image(systemName: "doc.text")
                  Text(service[i])
               }
            }
         }
         
         Section(header: Text("Функциональные")) {
            ForEach(0..<functional.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.functional[i])) {
                  Image(systemName: "doc.text")
                  Text(functional[i])
               }
            }
         }
         
         Section(header: Text("Внутренний наряд")) {
            ForEach(0..<inner.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.inner[i])) {
                  Image(systemName: "doc.text")
                  Text(inner[i])
               }
            }
         }
      } // List
      .listStyle(InsetListStyle())
      .navigationBarTitle("Обязанности")
      .navigationBarTitle("", displayMode: .inline)
   }
}


// MARK: - ГДЗС
struct Service: View {
   
   @StateObject var fetchFrom = JSONParser()
   
   private var service = ["Обслуживание СИЗОД",
                          "Правила работы в СИЗОД",
                          "Звено и ПБ",
                          "Минимум оснащения"]
   
   var body: some View {
      List {
         Section {
            ForEach(0..<service.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.maintenance[i])) {
                  Image(systemName: "doc.text")
                  Text(service[i])
               }
            }
         }
      }
      .listStyle(InsetListStyle())
      .navigationBarTitle("ГДЗС")
      .navigationBarTitle("", displayMode: .inline)
   }
}


// MARK: - СИЗОД
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
      .navigationBarTitle("ТТХ СИЗОД")
      .navigationBarTitle("", displayMode: .inline)
   }
   
}



// MARK: - РТП
struct Leader: View {
   
   @StateObject var fetchFrom = JSONParser()
   
   private var service = ["5 решающих направлений",
                          "Кто является РТП",
                          "Обязанности РТП",
                          "Полномочия РТП",
                          "Оперативный штаб",
                          "Задачи оперативного штаба",
                          "Разведка пожара"]
   
   var body: some View {
      List {
         Section {
            ForEach(0..<service.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.leader[i])) {
                  Image(systemName: "doc.text")
                  Text(service[i])
               }
            }
         }
      }
      .listStyle(InsetListStyle())
      .navigationBarTitle("РТП")
      .navigationBarTitle("", displayMode: .inline)
   }
}

struct DeviceFeatures: View {
   var body: some View {
      Text("SomeText")
   }
   
}


// MARK: - Footer
struct FooterView: View {
   var body: some View {
      HStack {
         Spacer()
         
         VStack(spacing: 5) {
            HStack(spacing: 5) {
               Text("БрандМастер - ГДЗС")
               
               //                    Image("logo")
               //                        .resizable()
               //                        .frame(width: 20, height: 20)
               //                        .cornerRadius(4)
            }
            
            Text("Версия: 1.0")
            Text("Alexey Orekhov")
         }
         Spacer()
      }
      .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
      .padding()
   }
}
