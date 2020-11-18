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
    
    var fire = ["Поиск", "Обнаружен"]
    var work = ["Норма", "Сложные"]
    
    
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack {
                    
                    // Условия работы
                    HStack {
                        
                        ZStack {
                            Color.yellow
                                .shadow(radius: 45)
                            
                            VStack {
                                
                                Text("Очаг")
                                    .font(.headline)
                                
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
//                        .shadow(color: Color.gray, radius: 3)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 15)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
                        
                        ZStack {
                            Color.green
                            
                            VStack {
                                
                                Text("Условия")
                                    .font(.headline)
                                
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
                        
//                        .shadow(color: Color.gray, radius: 5)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 15)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
                    }
                    
                    
                    
                    // Время
                    VStack {
                        
                        Text("Время")
                            .font(.headline)
                        
                        HStack {
                            Text("Включения:")
                                .font(.headline)
                            
                            DatePicker("", selection: $enterTime, in: ...Date(), displayedComponents: .hourAndMinute)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        if fireStatus == 1 {
                            
                            HStack {
                                Text("У очага:")
                                    .font(.headline)
                                
                                DatePicker("", selection: $fireTime, in: ...Date(), displayedComponents: .hourAndMinute)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                            }
                            
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    // Состав звена
                    VStack {
                        
                        Stepper("Состав звена", value: $team, in: 2...5)
                            .font(.headline)
                            .disabled(fireStatus == 0)
                        
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    Spacer()
                }
                .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                
                .font(Font.custom("AppleSDGothicNeo-Regular", size: 20.0))
                .padding(10)
                .navigationBarTitle("Условия работы", displayMode: .large)
                .navigationBarItems(
                    trailing:
                        Button("Рассчитать", action: {
                            
                        }))
                .environment(\.locale, Locale.init(identifier: "ru"))

            }
        }
        
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
            
            TextField("P очага.", text: $fireValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
//        .ignoresSafeArea(.keyboard, edges: .bottom)
        .keyboardType(.decimalPad)
        
    }
}

