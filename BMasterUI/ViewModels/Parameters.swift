//
//  Parameters.swift
//  BMaster
//
//  Created by Алексей on 27.02.2021.
//

import SwiftUI

/// Типы дыхательного аппарата
enum DeviceType: String, CaseIterable, Codable {
    case air = "ДАСВ"
    case oxigen = "ДАСК"
}


/// Единицы измерения расчетов
enum MeasureType: String, CaseIterable, Codable {
    case kgc = "кгс/см\u{00B2}"
    case mpa = "МПа"
}

enum SolutionType {
    case full
    case simple
}

/*
 @Published var items = [ExpenseItem]() {
 didSet {
 if let encoded = try? JSONEncoder().encode(items) {
 UserDefaults.standard.set(encoded, forKey: "Items")
 }
 }
 }
 */

class Parameters: ObservableObject {
    
    // MARK: - Условия работы
    @Published var workConditions = WorkСonditions(fireStatus: false,
                                                   hardWork: false,
                                                   startTime: Date(),
                                                   fireTime: Date(),
                                                   startPressure: [300.0, 300.0, 300.0, 300.0, 300.0],
                                                   firePressure: [250.0, 250.0, 250.0, 250.0, 250.0],
                                                   minValue: 300.0,
                                                   teamSize: 3) {
        didSet {
            if let ecoded = try? JSONEncoder().encode(workConditions) {
                UserDefaults.standard.set(ecoded, forKey: "workConditions")
            }
        }
    }
    
    
    // MARK: - Настройки приложения
    @Published var appSettings = AppSettings(deviceType: DeviceType.air,
                                             measureType: MeasureType.kgc,
                                             isOnSignal: true,
                                             solutionType: false) {
        didSet {
            if let ecoded = try? JSONEncoder().encode(appSettings) {
                UserDefaults.standard.set(ecoded, forKey: "appSettings")
            }
        }
    }
    
    
    // MARK: - Настройки дыхательного аппарата
    @Published var deviceSettings = DeviceSettings(airVolume: 6.8,
                                                   airRate: 40.0,
                                                   airIndex: 1.1,
                                                   reductorPressure: 10.0,
                                                   airSignal: 55.0) {
        didSet {
            if let ecoded = try? JSONEncoder().encode(deviceSettings) {
                UserDefaults.standard.set(ecoded, forKey: "deviceSettings")
            }
        }
    }
    
    
    
    init() {
        loadSettings()
    }
    
    // Расход воздуха
    var airFlow: Double {
        get {
            switch appSettings.deviceType {
                case .air:
                    return deviceSettings.airIndex * deviceSettings.airRate
                case .oxigen:
                    return appSettings.measureType == .kgc ? 2.0 : 0.2
            }
        }
    }
    
    
    // Падение давления в звене
    var fallPressureData: [Double] {
        get {
            var fallArray = [Double]()
            for i in 0..<workConditions.teamSize {
                let fallValue = workConditions.startPressure[i] - workConditions.firePressure[i]
                fallArray.append(fallValue)
            }
            return fallArray
        }
    }
    
    // MARK: - METHODS Главный экран
    
    func writeWorkData(conditions: (fireStatus: Bool, hardWork: Bool, startTime: Date, fireTime: Date, startPressure: [String], firePressure: [String], minValue: String, teamSize: Int)) {
        
        workConditions.fireTime = conditions.fireTime
        workConditions.hardWork = conditions.hardWork
        workConditions.startTime = conditions.startTime
        workConditions.fireTime = conditions.fireTime
        workConditions.startPressure = conditions.startPressure.map({ $0.doubleValue })
        workConditions.firePressure = conditions.firePressure.map({ $0.doubleValue })
        workConditions.minValue = conditions.minValue.doubleValue
        workConditions.teamSize = conditions.teamSize
    }
    
    /// Преобразуем Double в String
    func obtainWorkData() -> (Bool, Bool, Date, Date, [String], [String], String, Int) {
        print("obtainWorkData")
        
        let fireStatus = workConditions.fireStatus
        let hardWork = workConditions.hardWork
        let startTime = workConditions.startTime
        let fireTime = workConditions.fireTime
        var startPressure = [String]()
        var firePressure = [String]()
        var minValue = String()
        
        let separator = Locale.current.decimalSeparator!
        
        switch appSettings.measureType {
            case .kgc:
                startPressure = workConditions.startPressure.map({ String(Int($0)) })
                firePressure = workConditions.firePressure.map({ String(Int($0)) })
                minValue = String(Int(workConditions.minValue))
                
            case .mpa:
                startPressure = workConditions.startPressure.map({ String($0).replacingOccurrences(of: ".", with: separator) })
                firePressure = workConditions.firePressure.map({ String($0).replacingOccurrences(of: ".", with: separator) })
                minValue = String(workConditions.minValue).replacingOccurrences(of: ".", with: separator)
        }
        
        let teamSize = workConditions.teamSize
        
        return (fireStatus, hardWork, startTime, fireTime, startPressure, firePressure, minValue, teamSize)
    }
    
    func setWorkType(hard: Bool) {
        switch hard {
            case true: workConditions.hardWork = true
            case false: workConditions.hardWork = false
        }
    }
    
    func setFireStatus(status: Bool) {
        switch status {
            case true: workConditions.fireStatus = true
            case false: workConditions.fireStatus = false
        }
    }
    
    // MARK: - METHODS Экран настроек {
    
    /// Конвертируем Double в String
    func obtainAppSettings() -> (DeviceType, MeasureType, Bool, Bool) {
        print("obtainAppSettings")
        
        let appSettings = (
            appSettings.deviceType,
            appSettings.measureType,
            appSettings.isOnSignal,
            appSettings.solutionType
        )
        
        return appSettings
    }
    
    func obtainDeviceSettings() -> (String, String, String, String, String) {
        print("obtainDeviceSettings")
        var airVolume, airRate, airIndex, reductorPressure, airSignal: String
        
        let separator = Locale.current.decimalSeparator!
        switch appSettings.measureType {
            case .kgc:
                airVolume =        String(deviceSettings.airVolume).replacingOccurrences(of: ".", with: separator)
                airRate =          String(Int(deviceSettings.airRate)).replacingOccurrences(of: ".", with: separator)
                airIndex =         String(deviceSettings.airIndex).replacingOccurrences(of: ".", with: separator)
                reductorPressure = String(Int(deviceSettings.reductorPressure)).replacingOccurrences(of: ".", with: separator)
                airSignal =        String(Int(deviceSettings.airSignal)).replacingOccurrences(of: ".", with: separator)
            case .mpa:
                airVolume =        String(deviceSettings.airVolume).replacingOccurrences(of: ".", with: separator)
                airRate =          String(deviceSettings.airRate).replacingOccurrences(of: ".", with: separator)
                airIndex =         String(deviceSettings.airIndex).replacingOccurrences(of: ".", with: separator)
                reductorPressure = String(deviceSettings.reductorPressure).replacingOccurrences(of: ".", with: separator)
                airSignal =        String(deviceSettings.airSignal).replacingOccurrences(of: ".", with: separator)
        }
        
        return (airVolume, airRate, airIndex, reductorPressure, airSignal)
    }
    
    func writeAppSettings(conditions: (deviceType: DeviceType, measureType: MeasureType, isOnSignal: Bool, solutionType: Bool)) {
        
        appSettings.deviceType = conditions.deviceType
        appSettings.measureType = conditions.measureType
        appSettings.isOnSignal = conditions.isOnSignal
        appSettings.solutionType = conditions.solutionType
    }
    
    func writeDeviceSettings(conditions: (airVolume: String, airRate: String, airIndex: String, reductorPressure: String, airSignal: String)) {
        
        deviceSettings.airVolume = conditions.airVolume.doubleValue
        deviceSettings.airRate = conditions.airRate.doubleValue
        deviceSettings.airIndex = conditions.airIndex.doubleValue
        deviceSettings.reductorPressure = conditions.reductorPressure.doubleValue
        deviceSettings.airSignal = conditions.airSignal.doubleValue
    }
    
    /// Установить тип аппарата
    func setDevice(type: DeviceType) {
        print("setDeviceType")
        switch type {
            case .air:
                appSettings.deviceType = .air
                deviceSettings.airVolume = 6.8
                deviceSettings.airSignal = 55
            case .oxigen:
                appSettings.deviceType = .oxigen
                deviceSettings.airVolume = 1.0
                deviceSettings.airSignal = 35
        }
    }
    
    /// Конвертировать  единицы измерения
    func setMeasure(type: MeasureType) {
        print("Convert values")
        if type != appSettings.measureType {
            appSettings.measureType = type
            switch type {
                case .mpa:
                    // переводим в кг
                    workConditions.startPressure = workConditions.startPressure.map({ $0 / 10.0 })
                    workConditions.firePressure = workConditions.firePressure.map({ $0 / 10.0 })
                    deviceSettings.reductorPressure /= 10
                    deviceSettings.airRate /= 10
                    deviceSettings.airSignal /= 10
                    workConditions.minValue /= 10
                    
                case .kgc:
                    // переводим в МПа
                    workConditions.startPressure = workConditions.startPressure.map({ $0 * 10.0 })
                    workConditions.firePressure = workConditions.firePressure.map({ $0 * 10.0 })
                    deviceSettings.reductorPressure *= 10
                    deviceSettings.airRate *= 10
                    deviceSettings.airSignal *= 10
                    workConditions.minValue *= 10
            }
        }
        
        print(workConditions.startPressure)
    }
    
    func resetParameters() {
        print("reset Parameters")
        workConditions = WorkСonditions(fireStatus: false,
                                        hardWork: false,
                                        startTime: Date(),
                                        fireTime: Date(),
                                        startPressure: [300.0, 300.0, 300.0, 300.0, 300.0],
                                        firePressure: [250.0, 250.0, 250.0, 250.0, 250.0],
                                        minValue: 300.0,
                                        teamSize: 3)
        
        appSettings = AppSettings(deviceType: DeviceType.air,
                                  measureType: MeasureType.kgc,
                                  isOnSignal: true,
                                  solutionType: false)
        
        deviceSettings = DeviceSettings(airVolume: 6.8,
                                        airRate: 40.0,
                                        airIndex: 1.1,
                                        reductorPressure: 10.0,
                                        airSignal: 55.0)
        
        
    }
    
    
    
    private func loadSettings() {
        if let workConditionsData = UserDefaults.standard.data(forKey: "workConditions") {
            if let decodedWorkСonditions = try? JSONDecoder().decode(WorkСonditions.self, from: workConditionsData) {
                workConditions = decodedWorkСonditions
            }
        }
        
        if let appSettingsData = UserDefaults.standard.data(forKey: "appSettings") {
            if let decodedAppSettings = try? JSONDecoder().decode(AppSettings.self, from: appSettingsData) {
                appSettings = decodedAppSettings
            }
        }
        
        if let workConditionsData = UserDefaults.standard.data(forKey: "deviceSettings") {
            if let decodedDeviceSettings = try? JSONDecoder().decode(DeviceSettings.self, from: workConditionsData) {
                deviceSettings = decodedDeviceSettings
            }
        }
        
        print("Настройки загружены")
    }
    
}

