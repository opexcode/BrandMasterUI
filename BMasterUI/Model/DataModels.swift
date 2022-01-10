//
//  Settings.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 05.09.2021.
//

import Foundation

/// Условия работы звена
struct WorkСonditions: Codable {
    var fireStatus: Bool
    var hardWork: Bool
    var startTime: Date
    var fireTime: Date
    var startPressure: [Double]
    var firePressure: [Double]
    var minValue: Double
    var teamSize: Int
}

/// Настройки дыхательного аппарата
struct DeviceSettings: Codable {
    var airVolume: Double
    var airRate: Double
    var airIndex: Double
    var reductorPressure: Double
    var airSignal: Double
}

/// Настройки приложения
struct AppSettings: Codable {
    var deviceType: DeviceType
    var measureType: MeasureType
    var isOnSignal: Bool
    var solutionType: Bool
    var airSignalFlag: Bool
//    var fontSize: Int? = nil
}
