//
//  SettingsView.swift
//  BMaster
//
//  Created by Алексей on 26.02.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var unit: String {
        switch vm.appSettings.measureType {
            case .kgc: return "кгс/см\u{00B2}"
            case .mpa: return "МПа"
        }
    }
    
    @ObservedObject var vm: Parameters
    
    @State private var appSettings = (deviceType: DeviceType.air,
                                      measureType: MeasureType.kgc,
                                      isOnSignal: true,
                                      solutionType: true)
    
    @State private var deviceSettings = (airVolume: "6.8",
                                         airRate: "40.0",
                                         airIndex: "1.1",
                                         reductorPressure: "10.0",
                                         airSignal: "55.0")
    
    @State private var resetAll: Bool = false
    
    
    
    var body: some View {
        
        NavigationView {
            List {
                // Section 0
                Section(footer: Text("")) {
                    
                    // MARK: - ТИП СИЗОВ
                    HStack {
                        Text("Тип СИЗОД")
                        
                        Spacer()
                        
                        Picker("\(appSettings.deviceType.rawValue)", selection: $appSettings.deviceType) {
                            ForEach(DeviceType.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: appSettings.deviceType) { newType in
                            vm.setDevice(type: newType)
                            appSettings = vm.obtainAppSettings()
                            deviceSettings = vm.obtainDeviceSettings()
                        }
                    }
                    
                    // MARK: - ЕДИНИЦЫ ИЗМЕРЕНИЯ
                    HStack {
                        Text("Единицы измерения")
                        
                        Spacer()
                        
                        Picker("\(appSettings.measureType.rawValue)", selection: $appSettings.measureType) {
                            ForEach(MeasureType.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: appSettings.measureType) { newType in
                            vm.setMeasure(type: newType)
                            appSettings = vm.obtainAppSettings()
                            deviceSettings = vm.obtainDeviceSettings()
                        }
                    }
                    
                    // MARK: - СИГНАЛ
                    Toggle(isOn: $appSettings.isOnSignal, label: {
                        Text("Учитывать сигнал")
                    })
                    
                    // MARK: - ПОДРОБНОЕ РЕШЕНИЕ
                    Toggle(isOn: $appSettings.solutionType, label: {
                        Text("Подробное решение")
                    })
                } // Section 0
                
                // Section 1
                Section(header: header) {
                    Group {
                        // MARK: - ВМЕСТИМОСТЬ БАЛЛОНА
                        ParameterRow(parameter: "Vб", description: "Объем баллона (л)", value: $deviceSettings.airVolume)
                        
                        if appSettings.deviceType != .oxigen {
                            // MARK: - РАССХОД ВОЗДУХА
                            ParameterRow(parameter: "Qвозд.", description: "Средний расход воздуха (л/мин)", value: $deviceSettings.airRate)
                            
                            // MARK: - КОЭФФИЦИЕНТ СЖАТИЯ
                            ParameterRow(parameter: "Ксж.", description: "Коэффициент сжимаемости воздуха", value: $deviceSettings.airIndex)
                        } // if
                        
                        // MARK: - ДАВЛЕНИЕ РЕДУКТОРА
                        ParameterRow(parameter: "Pуст.раб.", description: "P срабатывания редуктора (\(unit))", value: $deviceSettings.reductorPressure)
                        
                        
                        // MARK: - СИГНАЛЬНОЕ УСТРОЙСТВО
                        ParameterRow(parameter: "Сигнал", description: "P срабатывания сигнала (\(unit))", value: $deviceSettings.airSignal)
                        
                    } // Group
                } // Section 1
                
                // Section 2
                Section {
                    Button("Сбросить настройки", action: {
                        resetAll = true
                    })
                        .buttonStyle(BorderlessButtonStyle())
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .actionSheet(isPresented: $resetAll) {
                            ActionSheet(
                                title: Text("Сбросить настройки?"),
                                buttons: [
                                    .destructive(Text("OK")) {
                                        vm.resetParameters()
                                        appSettings = vm.obtainAppSettings()
                                        deviceSettings = vm.obtainDeviceSettings()
                                        resetAll = false
                                    },
                                    .cancel(Text("Отмена")) {
                                        resetAll = false
                                    }
                                ]
                                
                            )
                        }
                } // Section 2
            }
            .listStyle(.insetGrouped)
//            .navigationBarTitle("Настройки")
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Настройки")
            .navigationViewStyle(StackNavigationViewStyle())
        } // NavigationView
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear () {
            appSettings = vm.obtainAppSettings()
            deviceSettings = vm.obtainDeviceSettings()
        }
        .onDisappear() {
            vm.writeAppSettings(conditions: appSettings)
            vm.writeDeviceSettings(conditions: deviceSettings)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            vm.writeAppSettings(conditions: appSettings)
            vm.writeDeviceSettings(conditions: deviceSettings)
        }
    }
    
    
    var header: some View {
        Text("Параметры СИЗОД")
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 16))
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
            
            CustomTF(text: $value, keyType: .decimalPad, placeholder: "", fontSize: 20)
                .frame(width: 65)
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
        let separator =  Locale.current.decimalSeparator!
        
        if newValue.isEmpty {
            value = "0"
        }
        else if newValue[0] == "0" && newValue.count > 1 {
            if newValue[1] != separator {
                value = String(newValue.dropFirst())
            }
        }
        else if newValue.count > 4 {
            value = String(newValue.dropLast())
        }
        
        if newValue.last == Character(separator) {
            let oldValue = newValue.dropLast()
            if oldValue.contains(separator) {
                value = String(oldValue) //String(newValue.dropLast())
            }
        }
    }
}




