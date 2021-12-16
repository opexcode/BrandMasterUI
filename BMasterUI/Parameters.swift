//
//  Parameters.swift
//  BMaster
//
//  Created by Алексей on 27.02.2021.
//

import SwiftUI

/// Типы дыхательного аппарата
enum DeviceType: String, CaseIterable {
   case air = "ДАСВ"
   case oxigen = "ДАСК"
}


/// Единицы измерения расчетов
enum MeasureType: String, CaseIterable {
   case kgc = "кгс/см\u{00B2}"
   case mpa = "МПа"
}

enum SolutionType {
   case full
   case simple
}


class Parameters: ObservableObject {
   
   @AppStorage("fontSize") var fontSize: Int = 17
   
   // MARK: - Условия работы
   @Published var workConditions = WorkСonditions(fireStatus: false,
                                                  hardWork: false,
                                                  startTime: Date(),
                                                  fireTime: Date(),
                                                  startPressure: [300.0, 300.0, 300.0, 300.0, 300.0],
                                                  firePressure: [250.0, 250.0, 250.0, 250.0, 250.0],
                                                  minValue: 300.0,
                                                  teamSize: 3)
   
   
   // MARK: - Настройки приложения
   @Published var appSettings = AppSettings(deviceType: DeviceType.air,
                                            measureType: MeasureType.kgc,
                                            isOnSignal: true,
                                            solutionType: false,
                                            airSignalFlag: false)
   
   
   // MARK: - Настройки дыхательного аппарата
   @Published var deviceSettings = DeviceSettings(airVolume: 6.8,
                                                  airRate: 40.0,
                                                  airIndex: 1.1,
                                                  reductorPressure: 10.0,
                                                  airSignal: 55.0)
   
   
   
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
   
   
   
   // MARK: - METHODS
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
      
      print(workConditions.startPressure)
   }
   
   func resetParameters() {
      print("reset Parameters")
      self.workConditions = WorkСonditions(fireStatus: false,
                                           hardWork: false,
                                           startTime: Date(),
                                           fireTime: Date(),
                                           startPressure: [300.0, 300.0, 300.0, 300.0, 300.0],
                                           firePressure: [250.0, 250.0, 250.0, 250.0, 250.0],
                                           minValue: 300.0,
                                           teamSize: 3)
      
      self.appSettings = AppSettings(deviceType: DeviceType.air,
                                     measureType: MeasureType.kgc,
                                     isOnSignal: true,
                                     solutionType: false,
                                     airSignalFlag: false)
      
      self.deviceSettings = DeviceSettings(airVolume: 6.8,
                                           airRate: 40.0,
                                           airIndex: 1.1,
                                           reductorPressure: 10.0,
                                           airSignal: 55.0)
      
      
   }
   
}

