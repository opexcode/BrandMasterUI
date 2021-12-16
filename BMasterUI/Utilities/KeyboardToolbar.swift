//
//  KeyboardToolbar.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 10.12.2021.
//

import UIKit
import SwiftUI

struct InputTextfield: UIViewRepresentable {
   
   @Binding var text: String
   @State var keyType: UIKeyboardType
   
   func makeUIView(context: UIViewRepresentableContext<InputTextfield>) -> UITextField {
      let textfield = UITextField()
      textfield.isUserInteractionEnabled = true
      textfield.keyboardType = keyType
      textfield.borderStyle = .roundedRect
      textfield.textAlignment = .center
      textfield.delegate = context.coordinator
      
      // Toolbar
      let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
      let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
      toolBar.items = [doneButton]
      toolBar.setItems([.flexibleSpace(), doneButton], animated: true)
      textfield.inputAccessoryView = toolBar
      
      return textfield
   }
   
   func makeCoordinator() -> InputTextfield.Coordinator {
      return Coordinator(text: $text, keyType: keyType)
   }
   
   func updateUIView(_ uiView: UITextField, context: Context) {
      uiView.text = text
   }
   
   class Coordinator: NSObject, UITextFieldDelegate {
      @Binding var text: String
      @State var keyType: UIKeyboardType
      
      init(text: Binding<String>, keyType: UIKeyboardType) {
         _text = text
         self.keyType = keyType
      }
      
      func textFieldDidChangeSelection(_ textField: UITextField) {
         DispatchQueue.main.async {
            self.text = textField.text ?? ""
         }
      }
   }
}

extension  UITextField{
   @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
      self.resignFirstResponder()
   }
   
}
