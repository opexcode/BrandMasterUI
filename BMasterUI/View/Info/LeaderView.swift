//
//  LeaderView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 09.01.2022.
//

import SwiftUI

// MARK: - РТП
struct Leader: View {
   
   @StateObject var fetchFrom = JSONParser()
   
   private var service = ["5 решающих направлений",
                          "Кто является РТП",
                          "Обязанности РТП",
                          "Полномочия РТП",
                          "Оперативный штаб",
                          "Задачи оперативного штаба",
                          "Разведка пожара"]
   
   var body: some View {
      List {
         Section {
            ForEach(0..<service.count) { i in
               NavigationLink(destination: TextViewer(text: fetchFrom.json.leader[i])) {
                  Image(systemName: "doc.text")
                  Text(service[i])
               }
            }
         }
      }
      .listStyle(InsetListStyle())
      .navigationBarTitle("РТП")
      .navigationBarTitle("", displayMode: .inline)
   }
}
