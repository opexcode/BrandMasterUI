//
//  Info.swift
//  MasterUI
//
//  Created by Алексей on 18.11.2020.
//

import SwiftUI


struct Info: View {
	
	@State private var searchText = ""
	@State private var typing = false
	//	@ObservedObject var fetchFrom = JSONParser()
	
	var body: some View {
		
		NavigationView {
			
			VStack {
				// MARK: - SearchBar

				HStack {
					
					HStack {
						
						Image(systemName: "magnifyingglass")
							.foregroundColor(Color(.systemGray2))
						
						TextField("Поиск", text: $searchText)
							.autocapitalization(.none)
							.onTapGesture {
								self.typing = true
							}
						
						
						Button(action: {
							searchText = ""
						}) {
							Image(systemName: "xmark.circle.fill")
								.foregroundColor(Color(.systemGray2))
						}
					}
					.padding(8)
					.background(Color(.systemGray6))
					.cornerRadius(8)
					
					if typing {
						Button("Отмена", action: {
							self.endEditing(true)
							self.typing = false
							self.searchText = ""
						})
						.padding(.trailing, 7)
					}
				}
				.padding(.horizontal, 10)
				
				
				if searchText != "" {
					Search(text: searchText)
				}
                
                
				// MARK: - Menu
				
				else {
					List {
						Section {
							NavigationLink(destination: Service()) {
								Image(systemName: "star.fill")
								Text("Примечания к формулам")
							}
							
							NavigationLink(destination: Instructions()) {
								Image(systemName: "folder.fill")
									.foregroundColor(.blue)
								Text("Обязаности")
							}
							
							NavigationLink(destination: Service()) {
								Image(systemName: "folder.fill")
									.foregroundColor(.orange)
								Text("ГДЗС")
							}
							
							NavigationLink(destination: Devices()) {
								Image(systemName: "folder.fill")
									.foregroundColor(.green)
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
						.foregroundColor(.primary)
					}
					.listStyle(GroupedListStyle())
				}
			}
			.navigationBarTitle("Информация")
			// Скрываем клавиатуру
			.gesture(DragGesture().onChanged { _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
			.ignoresSafeArea(.keyboard, edges: .bottom)
		}
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
	
	func getText(from: String) -> String {
		
		if let text = searchDict()[from] {
			return text
		}
		
		return "fail"
	}
	
}

struct Search: View {
	var text: String
	var search = SearchTest()
	
	var body: some View {
		List {
			if text != "" {
				ForEach(search.array.filter{text == "" || $0.hasPrefix(text)}, id:\.self) { searchText in
					NavigationLink(destination: Display(text: search.getText(from: searchText))) {
						Text(searchText)
					}
				}
			}
		}
		.listStyle(InsetListStyle())
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
					NavigationLink(destination: Display(text: fetchFrom.json[0].service[i])) {
						Image(systemName: "doc.text")
						Text(service[i])
					}
				}
			}
			
			Section(header: Text("Функциональные").frame(height: 50)) {
				
				ForEach(0..<functional.count) { i in
					NavigationLink(destination: Display(text: fetchFrom.json[0].functional[i])) {
						Image(systemName: "doc.text")
						Text(functional[i])
					}
				}
			}
			
			Section(header: Text("Внутренний наряд").frame(height: 50)) {
				
				ForEach(0..<inner.count) { i in
					NavigationLink(destination: Display(text: fetchFrom.json[0].inner[i])) {
						Image(systemName: "doc.text")
						Text(inner[i])
					}
				}
			}
		}
		.navigationBarTitle("Обязанности")
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
					NavigationLink(destination: Display(text: fetchFrom.json[0].maintenance[i])) {
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
