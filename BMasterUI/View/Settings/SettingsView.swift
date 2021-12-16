//
//  SettingsView.swift
//  BMaster
//
//  Created by Алексей on 26.02.2021.
//

import SwiftUI

struct SettingsView: View {
   
   @Environment(\.colorScheme) var colorScheme
   @EnvironmentObject var parameters: Parameters
   
   @State private var airVolume: String = "6.8"
   @State private var airRate: String = "40"
   @State private var airIndex: String = "1.1"
   @State private var reductorPressure: String = "10"
   @State private var airSignal: String = "55"
   
   @State private var resetAll: Bool = false
   @State private var deviceType: DeviceType = .air
   @State private var measureType: MeasureType = .kgc
   
   var unit: String {
      switch parameters.appSettings.measureType {
         case .kgc: return "кгс/см\u{00B2}"
         case .mpa: return "МПа"
      }
   }
  
   
   var body: some View {
      
      NavigationView {
         List {
            // Section 0
            Section(footer: Text("")) {
               
               // MARK: - ТИП СИЗОВ
               HStack {
                  Text("Тип СИЗОД")
                  
                  Spacer()
                  
                  Picker("\(deviceType.rawValue)", selection: $deviceType) {
                     ForEach(DeviceType.allCases, id: \.self) { value in
                        Text(value.rawValue)
                     }
                  }
                  .pickerStyle(MenuPickerStyle())
                  .onChange(of: deviceType) { newType in
                     parameters.setDevice(type: newType)
                     self.getParametersFromModel()
                  }
               }
               
               // MARK: - ЕДИНИЦЫ ИЗМЕРЕНИЯ
               HStack {
                  Text("Единицы измерения")
                  
                  Spacer()
                  
                  Picker("\(measureType.rawValue)", selection: $measureType) {
                     ForEach(MeasureType.allCases, id: \.self) { value in
                        Text(value.rawValue)
                     }
                  }
                  .pickerStyle(MenuPickerStyle())
                  .onChange(of: measureType) { newType in
                     parameters.setMeasure(type: newType)
                     self.getParametersFromModel()
                  }
               }
               
               // MARK: - СИГНАЛ
               Toggle(isOn: $parameters.appSettings.isOnSignal, label: {
                  Text("Учитывать сигнал")
               })
               
               // MARK: - ПОДРОБНОЕ РЕШЕНИЕ
               Toggle(isOn: $parameters.appSettings.solutionType, label: {
                  Text("Подробное решение")
               })
            } // Section 0
            
            // Section 1
            Section(header: header) {
               Group {
                  // MARK: - ВМЕСТИМОСТЬ БАЛЛОНА
                  ParameterRow(parameter: "Vб", description: "Объем баллона (л)", value: $airVolume)
                  
                  if deviceType != .oxigen {
                     // MARK: - РАССХОД ВОЗДУХА
                     ParameterRow(parameter: "Qвозд.", description: "Средний расход воздуха (л/мин)", value: $airRate)
                     
                     // MARK: - КОЭФФИЦИЕНТ СЖАТИЯ
                     ParameterRow(parameter: "Ксж.", description: "Коэффициент сжимаемости воздуха", value: $airIndex)
                  } // if
                  
                  // MARK: - ДАВЛЕНИЕ РЕДУКТОРА
                  ParameterRow(parameter: "Pуст.раб.", description: "P срабатывания редуктора (\(unit))", value: $reductorPressure)
                  
                  
                  // MARK: - СИГНАЛЬНОЕ УСТРОЙСТВО
                  ParameterRow(parameter: "Сигнал", description: "P срабатывания сигнала (\(unit))", value: $airSignal)
                  
               } // Group
            } // Section 1
            
            // Section 2
            Section {
               Button("Сбросить настройки", action: {
                  self.resetAll = true
               })
                  .buttonStyle(BorderlessButtonStyle())
                  .font(.headline)
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                  .actionSheet(isPresented: $resetAll) {
                     ActionSheet(
                        title: Text("Сбросить настройки?"),
                        buttons: [
                           .destructive(Text("OK")) {
                              self.parameters.resetParameters()
                              self.getParametersFromModel()
                              self.resetAll = false
                           },
                           .cancel(Text("Отмена")) {
                              self.resetAll = false
                           }
                        ]
                        
                     )
                  }
            } // Section 2
         }
         .listStyle(.grouped)
//         .navigationViewStyle(.)
         .navigationBarTitle("Настройки", displayMode: .large)
         
      } // NavigationView
      .onTapGesture {
         UIApplication.shared.endEditing()
      }
      
      .onDisappear() {
         getDataFromTextFields()
      }
   }
   
   
   var header: some View {
      Text("Параметры СИЗОД")
         .font(Font.custom("AppleSDGothicNeo-Regular", size: 16))
   }
   
   
   // MARK: - METHODS
   
   /// Сохраняем данные из TextField
   private func getDataFromTextFields() {
      guard let airVolume = Double(self.airVolume) else { return }
      guard let airRate = Double(self.airRate) else { return }
      guard let airIndex = Double(self.airIndex) else { return }
      guard let reductorPressure = Double(self.reductorPressure) else { return }
      guard let airSignal = Double(self.airSignal) else { return }
      
      parameters.deviceSettings.airVolume = airVolume
      parameters.deviceSettings.airRate = airRate
      parameters.deviceSettings.airIndex = airIndex
      parameters.deviceSettings.reductorPressure = reductorPressure
      parameters.deviceSettings.airSignal = airSignal
   }
   
   /// Получем данные из модели для TextFields
   private func getParametersFromModel() {
      switch parameters.appSettings.measureType {
         case .kgc:
            self.airVolume =        String(parameters.deviceSettings.airVolume)
            self.airRate =          String(Int(parameters.deviceSettings.airRate))
            self.airIndex =         String(parameters.deviceSettings.airIndex)
            self.reductorPressure = String(Int(parameters.deviceSettings.reductorPressure))
            self.airSignal =        String(Int(parameters.deviceSettings.airSignal))
         case .mpa:
            self.airVolume =        String(parameters.deviceSettings.airVolume)
            self.airRate =          String(parameters.deviceSettings.airRate)
            self.airIndex =         String(parameters.deviceSettings.airIndex)
            self.reductorPressure = String(parameters.deviceSettings.reductorPressure)
            self.airSignal =        String(parameters.deviceSettings.airSignal)
      }
//      self.deviceType = parameters.appSettings.deviceType
//      self.measureType = parameters.appSettings.measureType
   }
   
}

// MARK: - TEXT FIELDS

struct ParameterRow: View {
   let parameter: String
   let description: String
   
   @Binding var value: String
   
   var body: some View {
      HStack {
         VStack(alignment: .leading) {
            Text(parameter)
            Text(description)
               .font(.custom("AppleSDGothicNeo-Regular", size: 15))
               .foregroundColor(.secondary)
         } // VStack
         
         Spacer()
         
         TextField("", text: $value) //, formatter: formatter)
            .font(.custom("AppleSDGothicNeo-Semibold", size: 20))
            .frame(width: 65)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: value) { newValue in
               checkTextField(value: &value, newValue: newValue)
            }
      } // HStack
   }
   
   /// Ограничиваем ввод значений
   /// - Parameters:
   ///   - value: Значение поля
   func checkTextField(value: inout String, newValue: String) {
      if newValue.isEmpty {
         value = "0"
      } else if newValue[0] == "0"  {
         value = String(newValue.dropFirst())
      }
   }
}




