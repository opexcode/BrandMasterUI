//
//  NewInventoryForm.swift
//  BMasterUI
//
//  Created by   imac on 16.05.2022.
//

import SwiftUI

struct NewInventoryForm<Presenting>: View where Presenting: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    var action: () -> ()
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting.disabled(isShowing)
                
                if isShowing {
                    VStack {
                        Text(self.title)
                        
                        TextField("Название", text: self.$text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onAppear { self.text = "" }
                        
                        HStack(spacing: 10) {
                            Button("Отмена") {
                                withAnimation {
                                    self.isShowing.toggle()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Button("Готово") {
                                action()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(colorScheme == .dark ? darkColor : Color.white)
                    .cornerRadius(10)
                    .frame(
                        width: deviceSize.size.width * 0.7,
                        height: deviceSize.size.height * 0.7
                    )
                    .transition(.scale)
                }
            }
        }
    }
    
}

extension View {
    func textFieldAlert(
        isShowing: Binding<Bool>,
        text: Binding<String>,
        title: String,
        action: @escaping ()->()
    ) -> some View {
        NewInventoryForm(
            isShowing: isShowing,
            text: text,
            presenting: self,
            title: title,
            action: action
        )
    }
}
