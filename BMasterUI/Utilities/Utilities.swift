//
//  Utilities.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 29.09.2021.
//

import SwiftUI


// MARK: - Скрываем клавиатуру
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}




extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}


// Автоматически подставляем точку в double значения
extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}


// Ограничиваем ввод значений в поле выбора значения
func checkTextField(type: MeasureType, value: inout String, newValue: String) {
    
    switch type {
        case .kgc:
            if newValue.isEmpty {
                value = "0"
            } else if newValue[0] == "0" && newValue.count > 1 {
                value = String(newValue.dropFirst())
            } else if newValue.count > 3 {
                value = String(newValue.dropLast())
            } else {
                if Int(newValue)! > 350 {
                    value = "350"
                }
            }
            
        case .mpa:
            
            let separator = ","
            
            if newValue.isEmpty {
                value = "0"
            }
            // Удаляем незначащий ноль вначале
            else if newValue[0] == "0" && newValue.count > 1 {
                if newValue[1] != separator {
                    value = String(newValue.dropFirst())
                }
            }
            // Допускаем ввод разделителя только если он отсутствует в значении
            else if newValue[newValue.count-1] == separator {
                let oldValue = newValue.dropLast()
                if oldValue.contains(separator) {
                    value = String(newValue.dropLast())
                }
            }
            // Ограничиваем длину значения
            else if newValue.count > 4 {
                value = String(newValue.dropLast())
            }
            // Подставляем точку автоматически
            else if newValue.count == 3 && !newValue.contains(separator)  {
                let last = newValue[newValue.count-1]
                if last != separator && last != "." {
                    value = newValue.dropLast() + separator + last
                }
            }
            // Ограничиваем величину значения
            else if newValue.doubleValue > 35.0 {
                value = "35\(separator)0"
            }
    }
}
