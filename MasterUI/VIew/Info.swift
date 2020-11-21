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
				}
			}
			
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Информация")
		}
		//		VStack {
		//			Text("БрандМастер - ГДЗС")
		//			Text("version 1.0")
		//		}
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
	}
}


// СИЗОД
struct Devices: View {
    let devices = ["", "", "", "", ""]
	var body: some View {
		Text("")
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
