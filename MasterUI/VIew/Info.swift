//
//  Info.swift
//  MasterUI
//
//  Created by Алексей on 18.11.2020.
//

import SwiftUI

struct Answer: Codable {
	var infoData: [InfoData]
}

struct InfoData: Codable {
	var service: [String]
	var functional: [String]
	var inner: [String]
	var maintenance: [String]
}

class FetchData: ObservableObject {
	
	@Published var json = [InfoData]()
	
	init() {
		parse()
	}
	
	func parse() {
		var d: Data?
		do {
			d = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "infoData", ofType: "json")!))
		} catch {
			print("Ошибка получения Data: \(error.localizedDescription)")
		}
		
		guard let data = d else {
			print("Error...")
			return
		}
		
		do {
			let answer = try JSONDecoder().decode(Answer.self, from: data)
			self.json = answer.infoData
		} catch {
			print("Error... \(error.localizedDescription)")
		}
	}
	
}



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
						Button("BUTTON", action: {
							if let url = URL(string: "https://apps.apple.com/ru/app/id1508823670") {
											UIApplication.shared.open(url, options: [:], completionHandler: nil)
										}
						})
						
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
	@ObservedObject var fetchFrom = FetchData()
	
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
	@ObservedObject var fetchFrom = FetchData()
	
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
