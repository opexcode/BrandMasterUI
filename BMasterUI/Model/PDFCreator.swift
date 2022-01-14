//
//  PDFCreator.swift
//  FireCalculator
//
//  Created by Алексей on 01.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

//import UIKit
import PDFKit

final class PDFCreator: NSObject {
    
    // MARK: - Private Properties
    let compute: Calculations
    var vm: Parameters
    
    
    
    init(parameters: Parameters) {
        self.vm = parameters
        self.compute = Calculations(parameters: parameters)
        print("PDFCreator init")
    }

    
    // Щрифты
    let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 16)!]
    let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]
    let bold = [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 16)!]
    let note = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]
    
    // PDF
    let format = UIGraphicsPDFRendererFormat()
    let pageWidth = 595.2     // A4 Width
    let pageHeight = 841.8     // A4 Height
    
    // Параметры расчетов
    
    private var value = String()
    private var minEnterPressure = String()
    private var minFirePressure = String()
    private var minValue = String()
    private var reductor = String()
    private var airRate = String()
    private var maxFallPresure = String()
    private var airFlow = String()
    private var startPressure = String()
    private var firePressure = String()
    private var capacity = String()
    private var airIndex = String()
    private let airIndexStr = "сж"
    
    // Номер газодымзащитника с наибольшим падением давления
    private var index: Int {
        get {
            return getIndex()
        }
    }
    //
    func getIndex() -> Int {
        guard let max = vm.fallPressureData.max() else { return 0 }
        guard let index = vm.fallPressureData.firstIndex(of: max) else { return 0 }
        return index
    }
    // MARK: - Private Methods
    
    private func PDFdataFormatter() {
        capacity = String(vm.deviceSettings.airVolume)
        airIndex = String(vm.deviceSettings.airIndex)
        
        switch vm.appSettings.measureType {
            case .kgc:
                value = "кгс/см\u{00B2}"
                minEnterPressure = String(Int(vm.workConditions.startPressure.min()!))
                minFirePressure = String(Int(vm.workConditions.firePressure.min()!))
                minValue = String(Int(vm.workConditions.minValue))
                reductor = String(Int(vm.deviceSettings.reductorPressure))
                airRate = String(Int(vm.deviceSettings.airRate))
                maxFallPresure = String(Int(vm.fallPressureData.max()!))
                airFlow = String(Int(vm.airFlow))
                startPressure = String(Int(vm.workConditions.startPressure[index]))
                firePressure = String(Int(vm.workConditions.firePressure[index]))
                
            case .mpa:
                value = "МПа"
                minEnterPressure = String(vm.workConditions.startPressure.min()!)
                minFirePressure = String(vm.workConditions.firePressure.min()!)
                minValue = String(vm.workConditions.minValue)
                reductor = String(vm.deviceSettings.reductorPressure)
                airRate = String(vm.deviceSettings.airRate)
                maxFallPresure = String(format:"%.1f", vm.fallPressureData.max()!)
                airFlow = String(vm.airFlow)
                startPressure = String(vm.workConditions.startPressure[index])
                firePressure = String(vm.workConditions.firePressure[index])
        }
    }
    
    
    // MARK: - Public Methods
    
    // Метод генерирует лист А4 c расчетами если очаг пожара найден.
    func generateForSearch() -> Data {
        // 1) Расчет общего времени работы (Тобщ)
        let totalTime = compute.totalTimeCalculation(minPressure: vm.workConditions.startPressure)
        // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
        let expectedTime = compute.expectedTimeCalculation(inputTime: vm.workConditions.startTime, totalTime: totalTime)
        // 3) Расчет давления для выхода (Рк.вых)
        var exitPressure = compute.exitPressureCalculation(maxDrop: vm.fallPressureData, hardChoice: vm.workConditions.hardWork)
        // Pквых округлям при кгс и не меняем при МПа
        var exitPString = vm.appSettings.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
        
        var airSignalFlag = false
    
        
        if vm.appSettings.isOnSignal && exitPressure <= vm.deviceSettings.airSignal {
            airSignalFlag = true
            exitPressure = vm.deviceSettings.airSignal
        }
        
        // 4) Расчет времени работы у очага (Траб)
        let workTime = compute.workTimeCalculation(minPressure: vm.workConditions.firePressure, exitPressure: exitPressure)
        // 5) Время подачи команды постовым на выход звена
        let  exitTime = compute.expectedTimeCalculation(inputTime: vm.workConditions.fireTime, totalTime: workTime)
        
        PDFdataFormatter()
        
        // PDF
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let context = context.cgContext
            
            //index
            String(index+1).draw(at: CGPoint(x: 510, y: 141), withAttributes: large)
            
            // 0
            
            var string = "= \(startPressure) - \(firePressure) = \(maxFallPresure) \(value)"
            string.draw(at: CGPoint(x: 310, y: 184), withAttributes: large)
            
            // 1
            switch vm.appSettings.deviceType {
                case .air:
                    string = "\(airRate) * K"
                    string.draw(at: CGPoint(x: 170, y: 289), withAttributes: large)
                    airIndexStr.draw(at: CGPoint(x: 220, y: 294), withAttributes: small)
                    
                    string = "\(airRate) * \(airIndex)"
                    string.draw(at: CGPoint(x: 335, y: 289), withAttributes: large)
                    
                case .oxigen:
                    airFlow.draw(at: CGPoint(x: 205, y: 289), withAttributes: large)
                    airFlow.draw(at: CGPoint(x: 365, y: 289), withAttributes: large)
            }
            string = "(\(minEnterPressure) - \(reductor)) * \(capacity)"
            string.draw(at: CGPoint(x: 308, y: 267), withAttributes: large)
            
            string = "= \(String(format:"%.1f", totalTime)) ≈ \(Int(totalTime)) мин."
            string.draw(at: CGPoint(x: 428, y: 280), withAttributes: large)
            
            //2
            let time = DateFormatter()
            time.dateFormat = "HH"
            string = "\(time.string(from: vm.workConditions.startTime))    +    = \(expectedTime)"
            string.draw(at: CGPoint(x: 320, y: 371), withAttributes: large)
            
            time.dateFormat = "mm"
            string = "\(time.string(from: vm.workConditions.startTime))     \(Int(totalTime))"
            string.draw(at: CGPoint(x: 340, y: 368), withAttributes: small)
            
            
            // 3
            var formulaPat = ""    // шаблон
            if vm.workConditions.hardWork {
                formulaPat = "P        = 2 * P            + P         "
                formulaPat.draw(at: CGPoint(x: 90, y: 478), withAttributes: bold)
                formulaPat = "к. вых                 макс. пад           уст. раб"
                formulaPat.draw(at: CGPoint(x: 98, y: 485), withAttributes: note)
                
                string = "= 2 * \(maxFallPresure) + \(reductor) = \(exitPString) \(value)"
                string.draw(at: CGPoint(x: 325, y: 478), withAttributes: large)
            } else {
                formulaPat = "P        = P            + P            /2 + P         "
                formulaPat.draw(at: CGPoint(x: 37, y: 478), withAttributes: bold)
                formulaPat = "к. вых         макс. пад         макс. пад                уст. раб"
                formulaPat.draw(at: CGPoint(x: 47, y: 485), withAttributes: note)
                
                string = "= \(maxFallPresure) + \(maxFallPresure)/2 + \(reductor) = \(exitPString) \(value)"
                string.draw(at: CGPoint(x: 344, y: 478), withAttributes: large)
            }
            
            
            if airSignalFlag {
                exitPString = vm.appSettings.measureType == .kgc ? String(Int(vm.deviceSettings.airSignal)) : String(format:"%.1f", floor(vm.deviceSettings.airSignal * 10) / 10)
                let signal = "\(exitPString) \(value)"
                signal.draw(at: CGPoint(x: 480, y: 514), withAttributes: large)
            }
            
            // 4
//            let someValue = vm.appSettings.airSignalFlag ? 36 : 0
            let someValue = airSignalFlag ? 36 : 0
            
            switch vm.appSettings.deviceType {
                case .air:
                    string = "\(airRate) * K"
                    string.draw(at: CGPoint(x: 180, y: 582+someValue), withAttributes: large)
                    airIndexStr.draw(at: CGPoint(x: 228, y: 587+someValue), withAttributes: small)
                    
                    string = "\(airRate) * \(airIndex)"
                    string.draw(at: CGPoint(x: 330, y: 582+someValue), withAttributes: large)
                    
                case .oxigen:
                    airFlow.draw(at: CGPoint(x: 190, y: 582+someValue), withAttributes: large)
                    airFlow.draw(at: CGPoint(x: 350, y: 582+someValue), withAttributes: large)
            }
            string = "(\(minFirePressure) - \(exitPString)) * \(capacity)"
            string.draw(at: CGPoint(x: 304, y: 561+someValue), withAttributes: large)
            
            string = "= \(String(format:"%.1f", floor(workTime*10)/10)) ≈ \(Int(workTime)) мин."
            string.draw(at: CGPoint(x: 433, y: 571+someValue), withAttributes: large)
            
            // 5
            time.dateFormat = "HH"
            string = "\(time.string(from: vm.workConditions.fireTime))    +    = \(exitTime)"
            string.draw(at: CGPoint(x: 310, y: 686+someValue), withAttributes: large)
            
            time.dateFormat = "mm"
            string = "\(time.string(from: vm.workConditions.fireTime))     \(Int(workTime))"
            string.draw(at: CGPoint(x: 330, y: 681+someValue), withAttributes: small)
            
            // Имя файла PDF-шаблона
            let fileName = airSignalFlag ? "signal" : "PatternForFound"
            let path = Bundle.main.path(forResource: fileName, ofType: "pdf")
            let url = URL(fileURLWithPath: path!)
            let document = CGPDFDocument(url as CFURL)
            let page = document?.page(at: 1)
            UIColor.white.set()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.drawPDFPage(page!)
        }
        return data
    }
    
    
    // MARK: - NOT FOUND
    /// Метод генерирует лист А4 c расчетами если очаг пожара не найден.
    func generateForFire() -> Data {
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
        
        // Коэффициент, учитывающий необходимый запас воздуха
        var ratio: String
        // при сложных условиях = 3, при простых = 2.5
        vm.workConditions.hardWork ? (ratio = "3") : (ratio = "2.5")
        
        PDFdataFormatter()
        
        // PDF
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let context = context.cgContext
            var print: String
            // Координаты констант и вычисляемых значений на листе A4
            // 1
            print = "\(minValue) - \(reductor)"
            print.draw(at: CGPoint(x: 357, y: 205), withAttributes: large)
            
            ratio.draw(at: CGPoint(x: 255, y: 225), withAttributes: large)
            ratio.draw(at: CGPoint(x: 385, y: 225), withAttributes: large)
            
            print = "= \(maxDropString) \(value)"
            print.draw(at: CGPoint(x: 435, y: 215), withAttributes: large)
            
            // 2
            print = "\(minValue) - \(maxDropString) = \(exitPString) \(value)"
            print.draw(at: CGPoint(x: 350, y: 330), withAttributes: large)
            
            // 3
            switch vm.appSettings.deviceType {
                case .air:
                    print = "\(airRate) * K                  \(airRate) * \(airIndex)"
                    print.draw(at: CGPoint(x: 172, y: 485), withAttributes: large)
                    airIndexStr.draw(at: CGPoint(x: 216, y: 492), withAttributes: small)
                    
                case .oxigen:
                    airFlow.draw(at: CGPoint(x: 200, y: 485), withAttributes: large)
                    airFlow.draw(at: CGPoint(x: 310, y: 485), withAttributes: large)
                    
            }
            print = "\(maxDropString) * \(capacity)"
            print.draw(at: CGPoint(x: 283, y: 465), withAttributes: large)
            
            print = "= \(String(format:"%.1f", floor(timeDelta * 10) / 10)) ≈ \(Int(timeDelta)) мин." //
            print.draw(at: CGPoint(x: 365, y: 475), withAttributes: large)
            
            //4
            let time = DateFormatter()
            time.dateFormat = "HH"
            print = "\(time.string(from: vm.workConditions.startTime))    +    = \(exitTime)"
            print.draw(at: CGPoint(x: 313, y: 590), withAttributes: large)
            
            time.dateFormat = "mm"
            time.string(from: vm.workConditions.startTime).draw(at: CGPoint(x: 333, y: 585), withAttributes: small)
            String(Int(timeDelta)).draw(at: CGPoint(x: 360, y: 585), withAttributes: small)
            
            // Подставляем PDF шаблон с формулами
            let path = Bundle.main.path(forResource: "PatternForNotFound", ofType: "pdf")!
            let url = URL(fileURLWithPath: path)
            let document = CGPDFDocument(url as CFURL)
            let page = document?.page(at: 1)
            UIColor.white.set()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.drawPDFPage(page!)
        }
        return data
    }
    
}
