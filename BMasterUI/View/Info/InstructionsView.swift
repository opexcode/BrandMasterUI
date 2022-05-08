//
//  InstructionsView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 09.01.2022.
//

import SwiftUI

// MARK: - Обязанности
struct InstructionsView: View {
   
   @StateObject var fetchFrom = JSONParser()
   
   private var service = ["Командир звена",
                          "Газодымозащитник",
                          "Постовой",
                          "При использовании ДАСК",
                          "При использовании ДАСВ"]
   
   private var functional = ["Помощник НК",
                             "Командир отделения",
                             "Пожарный",
                             "Водитель ПА"]
   
   private var inner = ["Дежурный по подразделению",
                        "Дневальный по гаражу",
                        "Дневальный по помещениям",
                        "Постовой у фасада"]
   
   
   var body: some View {
      List {
         Section(header: Text("ГДЗС")) {
            ForEach(0..<service.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.service[i])) {
                  Image(systemName: "doc.text")
                  Text(service[i])
               }
            }
         }
         
         Section(header: Text("Функциональные")) {
            ForEach(0..<functional.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.functional[i])) {
                  Image(systemName: "doc.text")
                  Text(functional[i])
               }
                
            }
         }
         
         Section(header: Text("Внутренний наряд")) {
            ForEach(0..<inner.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.inner[i])) {
                  Image(systemName: "doc.text")
                  Text(inner[i])
               }
            }
         }
      } // List
      .listStyle(InsetListStyle())
      .navigationBarTitle("Обязанности")
      .navigationBarTitle("", displayMode: .inline)
       
   }
}


struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
