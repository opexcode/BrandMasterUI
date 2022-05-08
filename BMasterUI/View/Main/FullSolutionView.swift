//
//  ResultPageView.swift
//  BMaster
//
//  Created by Алексей on 06.03.2021.
//

import SwiftUI

struct FullSolutionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var parameters: Parameters
    @State var orientation = UIDevice.current.orientation
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    //    @ViewBuilder
    var body: some View {
        let pdf = PDFCreator(parameters: parameters)
        
        PDFViewUI(
            data: parameters.workConditions.fireStatus ?
            pdf.generateForSearch() : pdf.generateForFire()
        )
        
        //        return Group {
        //            if parameters.workConditions.fireStatus {
        //                PDFViewUI(data: pdf.generateForSearch())
        //            } else {
        //                PDFViewUI(data: pdf.generateForFire())
        //            }
        //        }
        
        .ignoresSafeArea(edges: .bottom)
        //        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    actionSheet(data: parameters.workConditions.fireStatus ? pdf.generateForSearch() : pdf.generateForFire())
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            // Custom Back-button
            //            ToolbarItem(placement: .navigationBarLeading) {
            //                Button(action: {
            //                    presentationMode.wrappedValue.dismiss()
            //                }) {
            //                    HStack(spacing: 10) {
            //                        Image(systemName: "chevron.left")
            //                        Text("Назад")
            //                    }
            //                }
            //            }
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

