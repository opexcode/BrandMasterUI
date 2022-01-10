//
//  DevicesView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 09.01.2022.
//

import SwiftUI


// MARK: - СИЗОД
struct Devices: View {
    
    let features =  [
        "АП Омега":                 [
            "29,4 МПа\n300кгс/см\u{00B2}",
            "0,45-0,9 МПа\n(4,5-9,0 кгс/см\u{00B2})",
            "1,1-1,8 МПа\n(11-18 кгс/см\u{00B2})",
            "4,9-6,3 МПа\n(49-63 кгс/см\u{00B2})",
            "200-400 Па\n(20-40 мм вод. ст.",
            "350 Па\n(35 мм вод. ст.)",
            "0,7 кг",
            "10 лет"
        ],
        "ПТС Базис":                [
            "29,4 МПа\n300кгс/см\u{00B2}",
            "0,6-0,9 МПа\n(6,0-9,0 кгс/см\u{00B2})",
            "1,3-2,0 МПа\n(12-20 кгс/см\u{00B2})",
            "6,0-5,0 МПа\n(60-50 кгс/см\u{00B2})",
            "200-400 Па\n(20-40 мм вод. ст.",
            "350 Па\n(35 мм вод. ст.)",
            "1,0 кг",
            "10 лет"
        ],
        "ПТС Профи М/МП":           [
            "29,4 МПа\n300кгс/см\u{00B2}",
            "0,55-0,9 МПа\n(5,5-9,0 кгс/см\u{00B2})",
            "1,2-2,0 МПа\n(11-18 кгс/см\u{00B2})",
            "6,0-5,0 МПа\n(60-50 кгс/см\u{00B2})",
            "150-400 Па\n(15-40 мм вод. ст.",
            "350 Па\n(35 мм вод. ст.)",
            "1,0 кг",
            "10 лет"
        ],
        "AirGO MSA":                [
            "29,4 МПа\n300кгс/см\u{00B2}",
            "0,6-0,8 МПа\n(6,0-8,0 кгс/см\u{00B2})",
            "1,1 МПа\n(11 кгс/см\u{00B2})",
            "6,0-5,0 МПа\n(60-50 кгс/см\u{00B2})",
            "250-390 Па\n(25-39 мм вод. ст.",
            "350 Па\n(35 мм вод. ст.)",
            "0,5 кг",
            "10 лет"
        ],
        "Drager PSS 3000/5000":     [
            "29,4 МПа\n300кгс/см\u{00B2}",
            "0,65-1,0 МПа\n(6,5-10,0 кгс/см\u{00B2})",
            "1,3-2,0 МПа\n(13-20 кгс/см\u{00B2})",
            "6,0-5,0 МПа\n(60-50 кгс/см\u{00B2})",
            "180-300 Па\n(18-30 мм вод. ст.",
            "350 Па\n(35 мм вод. ст.)",
            "",
            ""
        ]
    ]
    
    let manuals = [
        "АП Омега":               "http://idsas.ru/pozharnaja-bezopasnost/pasport/omega_rukovodstvo.pdf",
        "ПТС Базис":              "https://disk.yandex.ru/i/DwR3ffuNhedicA",
        "ПТС Профи М/МП":         "https://disk.yandex.ru/d/EFKTr8w9ha4nTQ",
        "AirGO MSA":              "http://s7d9.scene7.com/is/content/minesafetyappliances/OPM_AirGo_10082058_RU",
        "Drager PSS 3000/5000":   "https://www.sbgaz.ru/upload/iblock/5b0/instruktsiya-pss-5000.pdf"
    ]
    
    @Environment(\.openURL) var openURL
    @State private var showAlert: Bool = false
    @State private var url: String = ""
    
    var body: some View {
        List {
            ForEach(manuals.sorted(by: >), id: \.key) { device, url in
                NavigationLink(destination: DeviceFeatures(title: device, features: features[device]!)) {
                    Text(device).fixedSize()
                    Spacer()
                    
                    Button("PDF") {
                        self.url = url
                        showAlert.toggle()
                    }
                    .foregroundColor(.blue)
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Перейти по внешней ссылке?"),
                    primaryButton: .default(Text("OK"), action: {
                        let manualUrl = URL(string: self.url)!
                        openURL(manualUrl)
                    }),
                    secondaryButton: .cancel(Text("Отмена")) {
                        showAlert = false
                    })
            }
        }
        .listStyle(InsetListStyle())
        .navigationTitle("ТТХ СИЗОД")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

