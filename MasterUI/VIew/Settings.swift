//
//  Settings.swift
//  MasterUI
//
//  Created by Алексей on 14.11.2020.
//

import SwiftUI

/*
enum DeviceType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case air
    case oxy
}

enum MeasureType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case kgc
    case mpa
}
*/


struct Settings: View {
    
    @State private var isOnAccuracy = false
    @State private var isOnSignal = true
    @State private var isOnSimple = true
    
    @State private var type = 0
    @State private var measure = 0
    
    @State private var airVolume = ""
    
    private var deviceType = ["ДАСВ", "ДАСК"]
    private var measureType = ["кгс/см\u{00B2}", "МПа"]
    
    var body: some View {
        NavigationView {
            
            Form {
                
                // Section 0
                Section(footer: Text("")) {
                    
                    HStack {
                        
                        Picker("Тип СИЗОД", selection: $type) {
                            
                            ForEach(0..<deviceType.count) {
                                Text(self.deviceType[$0])
                                
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Spacer()
                        
                        Text("\(deviceType[type])")
                    }
                    
                    HStack {
                        
                        Picker("Единицы измерения", selection: $measure) {
                            
                            ForEach(0..<measureType.count) {
                                
                                Text(self.measureType[$0])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Spacer()
                        
                        Text("\(measureType[measure])")
                    }
                    
                    
                    Toggle(isOn: $isOnAccuracy, label: {
                        
                        Text("Точность")
                    })
                    
                    Toggle(isOn: $isOnSignal, label: {
                        
                        Text("Учитывать сигнал")
                    })
                    
                    Toggle(isOn: $isOnSimple, label: {
                        
                        Text("Подробное решение")
                    })
                }
                
                // Section 1
                Section(header: Text("Параметры сизод")) {
                    
                    Group {
                        // Вместимость баллона
                        HStack {
                            
                            VStack(alignment: .leading) {
                                
                                Text("Vб")
                                    .font(.system(size: 17, weight: .semibold))
                                
                                Text("Объем баллона (л)")
                                    .font(.system(size: 14, weight: .light))
                            }
                            
                            ValueField()
                        }
                        
                        
                        if type != 1 {
                            VStack {
                                // Средний расход воздуха
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text("Qвозд.")
                                            .font(.system(size: 17, weight: .semibold))
                                        
                                        Text("Средний расход воздуха (л/мин)")
                                            .font(.system(size: 14, weight: .light))
                                    }
                                    
                                    ValueField()
                                }
                                
                                // Коэффициент сжатия воздуха
                                
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text("Ксж.")
                                            .font(.system(size: 17, weight: .semibold))
                                        
                                        Text("Коэффициент сжимаемости воздуха")
                                            .font(.system(size: 14, weight: .light))
                                    }
                                    
                                    ValueField()
                                }
                            }
                        }
                        
                        // Давление устойчивой работы редуктора
                        HStack {
                            
                            VStack(alignment: .leading) {
                                
                                Text("Pуст.раб.")
                                    .font(.system(size: 17, weight: .semibold))
                                
                                Text("Давление редуктора (кгс/см\u{00B2})")
                                    .font(.system(size: 14, weight: .light))
                            }
                            
                            ValueField()
                        }
                        
                        // Сигнальное устройство
                        HStack {
                            
                            VStack(alignment: .leading) {
                                
                                Text("Сигнал")
                                    .font(.system(size: 17, weight: .semibold))
                                
                                Text("Давление срабатывания сигнала (кгс/см\u{00B2})")
                                    .font(.system(size: 14, weight: .light))
                            }
                            
                            ValueField()
                        }
                    }
                }
                
                // Section 2
                Section {
                    
                    Button("Сбросить настройки", action: {})
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("Настройки")
            .padding(-5)
        }
    }
    
}




struct ValueField: View {
    @State private var fieldValue: String = ""
    var body: some View {
        Spacer()
        
        TextField("", text: $fieldValue)
            .font(.system(size: 20, weight: .semibold))
            .frame(width: 65)
            .multilineTextAlignment(.center)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
