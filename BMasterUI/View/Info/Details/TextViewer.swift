//
//  QWe.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 06.11.2021.
//

import SwiftUI

struct TextViewer: View {
   @State var text: String
   @StateObject var settings = Settings()
   
   var body: some View {
      ScrollView {
          Text(text)
             .padding()
             .font(.custom("AppleSDGothicNeo-Regular", size: CGFloat(settings.fontSize)))
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
         Stepper("", value: $settings.fontSize, in: 14...25)
      }
      .onAppear() {
         UIApplication.shared.endEditing()
      }
      .onChange(of: settings.fontSize) { newValue in
          settings.fontSize = newValue
      }
   }
   
}
