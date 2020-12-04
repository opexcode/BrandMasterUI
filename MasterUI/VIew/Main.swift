//
//  Main.swift
//  MasterUI
//
//  Created by Алексей on 14.11.2020.
//

import SwiftUI

struct Main: View {
    
    @State private var fireStatus = 0
    @State private var workStatus = 0
    
    @State private var enterTime = Date()
    @State private var fireTime = Date()
    
    @State private var minValue = String()
    
    @State private var team = 3
    
    @State private var value: CGFloat = 0
    
    var fire = ["ПОИСК", "У ОЧАГА"]
    var work = ["НОРМА", "СЛОЖНЫЕ"]
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack {
                    
                    // Условия работы
                    HStack {
                        
                        ZStack {
                            colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color.white
                            
                            VStack {
                                
                                HStack {
                                    if fireStatus == 1 {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.red)
                                            .shadow(radius: 2)
                                    } else {
                                        Image(systemName: "flame")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text("Очаг")
                                        .font(.headline)
                                }
                                
                                Picker(selection: $fireStatus, label: Text("")) {
                                    
                                    ForEach(0..<fire.count) { index in
                                        
                                        Text(self.fire[index]).tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding(5)
                        }
                        .cornerRadius(8.0)
                        .shadow(color: Color.gray, radius: 3)
                        
                        ZStack {
                            colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color.white
                            
                            VStack {
                                
                                HStack {
                                    
                                    Image(systemName: "hammer")
                                    Text("Условия")
                                        .font(.headline)
                                }
                                
                                Picker(selection: $workStatus, label: Text("")) {
                                    
                                    ForEach(0..<work.count) { index in
                                        
                                        Text(self.work[index]).tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding(5)
                        }
                        .cornerRadius(8.0)
                        .shadow(color: Color.gray, radius: 3)
                    }
                    
                    
                    
                    // Время
                    ZStack {
                        colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color.white
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "clock")
                                Text("Время")
                                    .font(.headline)
                            }
                            
                            HStack {
                                Text("Включения:")
                                    .font(.headline)
                                
                                DatePicker("Включения:", selection: $enterTime, in: ...Date(), displayedComponents: .hourAndMinute)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                            }
                            .frame(height: 35)
                            
                            
                            if fireStatus == 1 {
                                
                                Divider()
                                
                                HStack {
                                    Text("У очага:")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $fireTime, in: ...Date(), displayedComponents: .hourAndMinute)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                }
                                .frame(height: 35)
                                
                            }
                        }
                        .padding()
                    }
                    .cornerRadius(8.0)
                    .shadow(color: Color.gray, radius: 3)
                    
                    // Состав звена
                    ZStack {
                        
                        colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color.white
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Stepper("Состав звена", value: $team, in: 2...5)
                                    .font(.headline)
                                    .disabled(fireStatus == 0)
                                
                            }
                            //							Divider()
                            
                            if fireStatus == 0 {
                                TextField("P min. вкл.", text: $minValue)
                                    .frame(width: 90)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                            }
                            else {
                                
                                ForEach((1...team), id: \.self) {
                                    TeamRow(num: $0)
                                        .frame(width: 220)
                                }
                            }
                            
                        }
                        .padding()
                    }
                    .cornerRadius(8.0)
                    .shadow(color: Color.gray, radius: 3)
                    Spacer()
                }
                .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                
                .font(Font.custom("AppleSDGothicNeo-Regular", size: 20.0))
                .padding(10)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        Button("Рассчитать", action: {
                            
                        }))
                .environment(\.locale, Locale.init(identifier: "ru"))
                
            }
            
            //            .background(Color.yellow.edgesIgnoringSafeArea(.all))
            .background(colorScheme == .dark ?  Color(UIColor.systemBackground) : Color(red: 242/255, green: 242/255, blue: 242/255))//.edgesIgnoringSafeArea(.all)
        }
        //        .edgesIgnoringSafeArea(.all)
        
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}


struct TeamRow: View {
    @State private var enterValue: String = ""
    @State private var fireValue: String = ""
    var num: Int
    
    var body: some View {
        
        HStack {
            TextField("P вкл.", text: $enterValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("\(num)")
                .font(Font.body.bold())
            
            TextField("P очага.", text: $fireValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        //        .ignoresSafeArea(.keyboard, edges: .bottom)
        .keyboardType(.decimalPad)
        
    }
}

