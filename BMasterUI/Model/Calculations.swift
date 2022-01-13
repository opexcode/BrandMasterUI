import Foundation

final class Calculations {
    
    // MARK: - Псевдонимы
    
   var parameters: Parameters
   
   init(parameters: Parameters) {
      self.parameters = parameters
   }
   
    
    // MARK: - Функции расчетов параметров работы, если очаг найден.
    
    // 1) Расчет общего времени работы (Тобщ)
    func totalTimeCalculation(minPressure: [Double]) -> Double {
        
       let totalTime = (minPressure.min()! - parameters.deviceSettings.reductorPressure) * parameters.deviceSettings.airVolume / parameters.airFlow
        return totalTime
    }
    
    
    // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
    func expectedTimeCalculation(inputTime: Date, totalTime: Double) -> String {
        
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        let strDate = time.string(from: (inputTime + floor(totalTime) * 60))
        
        return strDate
    }
    
    
    // 3) Расчет давления для выхода (Рк.вых) ..
    func exitPressureCalculation(maxDrop: [Double], hardChoice: Bool) -> Double {
        
        var exitPressure: Double
        let hardWork = 2 * maxDrop.max()! + parameters.deviceSettings.reductorPressure
        let normalWork = maxDrop.max()! + maxDrop.max()! / 2 + parameters.deviceSettings.reductorPressure
        exitPressure = hardChoice ? hardWork : normalWork
        
//        if parameters.appSettings.isOnSignal {
//            if exitPressure < parameters.deviceSettings.airSignal {
//                exitPressure = parameters.deviceSettings.airSignal
//            }
//        }
        
        return exitPressure
    }
    
    
    // 4) Расчет времени работы у очага (Траб)
    func workTimeCalculation(minPressure: [Double], exitPressure: Double) -> Double {
        
       let workTime = (minPressure.min()! - exitPressure) * parameters.deviceSettings.airVolume / parameters.airFlow
        return workTime
    }
    
    
    // MARK: - Функции расчетов параметров работы, если очаг не найден.
    
    // 1) Расчет максимального расхода давления при поиске очага
    func maxDropCalculation(minPressure: Double, hardChoice: Bool) -> Double {
        let hardValue = hardChoice ? 3 : 2.5
        let pressure = (minPressure - parameters.deviceSettings.reductorPressure) / hardValue
        return pressure
    }
    
    // 2) Расчет давления к выходу
    func exitPressureCalculation(minPressure: Double, maxDrop: Double) -> Double {
        let pressure = (minPressure - maxDrop)
        return pressure
    }
    
    // 3) Расчет промежутка времени с вкл. до подачи команды дТ
    func deltaTimeCalculation(maxDrop: Double) -> Double {
       let pressure = (maxDrop * parameters.deviceSettings.airVolume) / parameters.airFlow
        return pressure
    }
}
