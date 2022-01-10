//
//  SmokeServiceView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 09.01.2022.
//

import SwiftUI

// MARK: - ГДЗС
struct SmokeServiceView: View {
   
   @StateObject var fetchFrom = JSONParser()
   
   private var service = ["Обслуживание СИЗОД",
                          "Правила работы в СИЗОД",
                          "Звено и ПБ",
                          "Минимум оснащения"]
   
   var body: some View {
      List {
         Section {
            ForEach(0..<service.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.maintenance[i])) {
                  Image(systemName: "doc.text")
                  Text(service[i])
               }
            }
         }
      }
      .listStyle(InsetListStyle())
      .navigationBarTitle("ГДЗС")
      .navigationBarTitle("", displayMode: .inline)
   }
}

struct SmokeServiceView_Previews: PreviewProvider {
    static var previews: some View {
        SmokeServiceView()
    }
}
