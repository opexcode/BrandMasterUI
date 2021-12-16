//
//  JSONParser.swift
//  MasterUI
//
//  Created by Алексей on 21.11.2020.
//

import SwiftUI

struct Answer: Codable {
   var infoData: [InfoData]
}

struct InfoData: Codable {
   var service: [String] = []
   var functional: [String] = []
   var inner: [String] = []
   var maintenance: [String] = []
   var leader: [String] = []
}

class JSONParser: ObservableObject {
   
   @Published var json = InfoData()
   
   init() {
      parse()
   }
   
   func parse() {
      var d: Data?
      do {
         d = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "infoData", ofType: "json")!))
      } catch {
         print("Ошибка получения Data: \(error.localizedDescription)")
      }
      
      guard let data = d else {
         print("Error...")
         return
      }
      
      do {
         let answer = try JSONDecoder().decode(InfoData.self, from: data)
         self.json = answer
      } catch {
         print("Error... \(error.localizedDescription)")
      }
   }
   
}
