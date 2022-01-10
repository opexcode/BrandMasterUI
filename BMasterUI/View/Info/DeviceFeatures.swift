//
//  DeviceFeatures.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 10.01.2022.
//

import SwiftUI

struct DeviceFeatures: View {
    let title: String
    let features: [String]
    
    let specs = [
        "Рабочее давление в баллоне",
        "Редуцированное давление при нулевом расходе воздуха",
        "Давление открытия предохранительного клапана редуктора",
        "Давление срабатывания сигнального устройства",
        "Избыточное давление в подмасочном пространстве лицевой части при нулевом расходе воздуха",
        "Фактическое сопротивление дыханию на выдохе при легочной вентиляции 30 дм/мин",
        "Масса спасательного устройства, не более",
        "Срок службы"
    ]
    
    var body: some View {
        List {
            ForEach(0..<specs.count, id: \.self) { i in
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(specs[i])
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Text(features[i])
                }
                .padding(.vertical, 10)
                .listRowBackground(i%2 == 0 ? Color.gray.opacity(0.1) : Color.clear)
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(title)
    }
    
}
