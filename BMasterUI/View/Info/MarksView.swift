//
//  MarksView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 03.11.2021.
//

import SwiftUI

struct MarksView: View {
   @EnvironmentObject var parameters: Parameters
   
   @State var orientation = UIDevice.current.orientation
   let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
      .makeConnectable()
      .autoconnect()
   
   
   var body: some View {
      let pdf = PDFCreator(parameters: parameters)
      
      PDFViewUI(data: pdf.marksViewer())
         .edgesIgnoringSafeArea(.all)
         .navigationBarTitleDisplayMode(.inline)
         .ignoresSafeArea(edges: .bottom)
         .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               Button(action: {
                  actionSheet(data: parameters.workConditions.fireStatus ? pdf.generateForSearch() : pdf.generateForFire())
               }) {
                  Image(systemName: "square.and.arrow.up")
               }
            }
         }
         .onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
         }
   }
   
   // Окно "поделиться"
   func actionSheet(data: Data) {
      let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
      UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
   }
   
}
