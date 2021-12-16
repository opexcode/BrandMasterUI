//
//  QWe.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 06.11.2021.
//

import SwiftUI

struct TextViewer: View {
   @State var text: String
   @EnvironmentObject var parameters: Parameters
   
   var body: some View {
      ScrollView {
         VStack {
            Text(text)
               .padding()
               .font(.custom("AppleSDGothicNeo-Regular", size: CGFloat(parameters.fontSize)))
         }
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
         Stepper("", value: $parameters.fontSize, in: 14...25)
      }
      .onAppear() {
         UIApplication.shared.endEditing()
      }
      .onChange(of: parameters.fontSize) { newValue in
         parameters.fontSize = newValue
      }
   }
   
}
