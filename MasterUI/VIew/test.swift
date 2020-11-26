//
//  test.swift
//  MasterUI
//
//  Created by Алексей on 25.11.2020.
//

import SwiftUI

struct test: View {
    var body: some View {
        Text("")
            /*
         NavigationView {
            VStack {
                
                TextField("Поиск...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                /*
                
                //-----------------------------
                List {
                    
                    if searchText != "" {
                        
                        ForEach(array.filter{searchText == "" || $0.hasPrefix(searchText)}, id:\.self) { searchText in
                            NavigationLink(destination: DisplayText(text: searchText)) {
                                Text(searchText)
                            }
                        }
                    }
                }
                 */
                //-----------------------------
                
                
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
                    
                    Section {
                        
                        HStack {
                            Image(systemName: "applelogo")
                            Link("Оценить БрандМастер", destination: URL(string: "https://apps.apple.com/ru/app/id1508823670")!)
                        }
                        
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Link("БрандМастер в VK", destination: URL(string: "https://vk.com/brmeister")!)
                        }
                        
                        HStack {
                            Image(systemName: "at.badge.plus")
                            Link("Написать разработчику", destination: URL(string: "mailto:bmasterfire@gmail.com")!)
                        }
                        
                        HStack {
                            Image(systemName: "lock.fill")
                            Link("Политика конфеденциальности", destination: URL(string: "https://alekseyorehov.github.io/BrandMaster/")!)
                        }
                    }
                    .foregroundColor(.primary)
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("Информация")
            // Скрываем клавиатуру
            .gesture(DragGesture().onChanged { _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
 */
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
