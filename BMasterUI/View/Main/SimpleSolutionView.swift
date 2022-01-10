//
//  SimpleSolutionView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 25.10.2021.
//

import SwiftUI

struct SimpleSolutionView: View {
    
    //   @EnvironmentObject var parameters: Parameters
    @ObservedObject var vm: Parameters
    
    var body: some View {
        return Group {
            if vm.workConditions.fireStatus {
                SolutionForFound(vm: vm)
            } else {
                SolutionForSearch(vm: vm)
            }
        }
        .navigationBarTitle("Результат")
    }
}


struct SolutionForFound: View {
    @ObservedObject var vm: Parameters
    @State private var signal = false
    
    var body: some View {
        let compute = Calculations(parameters: vm)
        let unit = vm.appSettings.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
        
        // 1) Расчет общего времени работы (Тобщ)
        let totalTime = compute.totalTimeCalculation(minPressure: vm.workConditions.startPressure)
        
        // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
        let expectedTime = compute.expectedTimeCalculation(inputTime: vm.workConditions.startTime, totalTime: totalTime)
        
        // 3) Расчет давления для выхода (Рк.вых)
        let exitPressure = compute.exitPressureCalculation(maxDrop: vm.fallPressureData, hardChoice: vm.workConditions.hardWork)
        
        // Pквых округлям при кгс и не меняем при МПа
        let exitPString = vm.appSettings.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
        
        // 4) Расчет времени работы у очага (Траб)
        let workTime = compute.workTimeCalculation(minPressure: vm.workConditions.firePressure, exitPressure: exitPressure)
        
        // 5) Время подачи команды постовым на выход звена
        let  exitTime = compute.expectedTimeCalculation(inputTime: vm.workConditions.fireTime, totalTime: workTime)
        
        VStack {
            List {
                
                SimpleCell(value: "\(Int(totalTime)) мин.",
                           description: "Общее время работы звена.", symbol: "Тобщ.")
                
                SimpleCell(value: "\(expectedTime)",
                           description: "Ожидаемое время возвращения звена из НДС.", symbol: "Твозвр.")
                
                SimpleCell(value: exitPString,
                           unit: unit,
                           description: "Давление при котором звену необходимо выходить из НДС.",
                           signal: self.signal,
                           symbol: "Рк.вых.")
                
                SimpleCell(value: "\(Int(workTime)) мин.",
                           description: "Время работы звена у очага.", symbol: "Траб.")
                
                SimpleCell(value: exitTime,
                           description: "Время подачи команды постовым на выход звена изВремя подачи команды постовым на выход звена из НДС.", symbol: "Тк.вых." )
                
            }
            .listStyle(InsetListStyle())
            .onAppear() {
                if vm.appSettings.isOnSignal {
                    if exitPressure == vm.deviceSettings.airSignal {
                        self.signal = true
                    }
                }
            }
            
            
        }
    }
}

struct SolutionForSearch: View {
    
    @ObservedObject var vm: Parameters
    @State private var signal = false
    
    var body: some View {
        let compute = Calculations(parameters: vm)
        
        let unit = vm.appSettings.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
        
        // 1) Расчет максимального возможного падения давления при поиске очага
        let maxDrop = compute.maxDropCalculation(minPressure: vm.workConditions.minValue, hardChoice: vm.workConditions.hardWork)
        
        // 2) Расчет давления к выходу
        let exitPressure = compute.exitPressureCalculation(minPressure: vm.workConditions.minValue, maxDrop: maxDrop)
        
        // 3) Расчет промежутка времени с вкл. до подачи команды дТ
        let timeDelta = compute.deltaTimeCalculation(maxDrop: maxDrop)
        
        // 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
        let exitTime = compute.expectedTimeCalculation(inputTime: vm.workConditions.startTime, totalTime: timeDelta)
        
        
        // Максимальное падение давления
        let maxDropString = vm.appSettings.measureType == .kgc ? (String(Int(maxDrop))) : (String(format:"%.1f", floor(maxDrop * 10) / 10))
        
        // Давление к выходу
        let exitPString = vm.appSettings.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", exitPressure))
        
        VStack {
            List {
                
                SimpleCell(value: maxDropString,
                           unit: unit,
                           description: "Максимально допустимое падение давления в звене.",
                           symbol: "Рмакс.пад.")
                
                SimpleCell(value: exitPString,
                           unit: unit,
                           description: "Давление при котором звену необходимо начать выход из НДС.", symbol: "Рк.вых.")
                
                SimpleCell(value: "\(Int(timeDelta)) мин.",
                           description: "Промежуток времени с момента включения до подачи постовым команды на выход.", symbol: "\u{0394}T.")
                
                SimpleCell(value: exitTime,
                           unit: unit,
                           description: "Время подачи постовым команды на выход.",
                           symbol: "Рвых.")
            }
            .listStyle(InsetListStyle())
            .onAppear() {
                if vm.appSettings.isOnSignal {
                    if exitPressure == vm.deviceSettings.airSignal {
                        self.signal = true
                    }
                }
            }
            
            
        }
    }
}
struct SimpleCell: View {
    @State var value: String
    @State var unit: String?
    @State var description: String
    @State var signal: Bool? = false
    @State var symbol: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(value)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 20))
                
                if unit != nil {
                    Text(unit ?? "")
                        .font(.custom("AppleSDGothicNeo-Bold", size: 20))
                }
                
                Spacer()
                
                if let signal = signal {
                    if signal {
                        Text("Выход звена по сигналу!")
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
                
                Text(symbol)
                    .font(.custom("AppleSDGothicNeo-Regular", size: 17))
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

