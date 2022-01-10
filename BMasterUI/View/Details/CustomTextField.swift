//
//  CustomTextField.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 06.01.2022.
//

import SwiftUI

struct CustomTF: UIViewRepresentable {

    // 1
    @Binding var text: String
    var keyType: UIKeyboardType
    var placeholder: String
    var fontSize: CGFloat
    
    
     // 2
    func makeUIView(context: UIViewRepresentableContext<CustomTF>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isUserInteractionEnabled = true
        textField.autocapitalizationType = .none
        textField.delegate = context.coordinator
        
        // Toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil )

        toolBar.items = [doneButton]
        toolBar.setItems([flexibleSpaceItem, doneButton], animated: true)
        textField.inputAccessoryView = toolBar

        return textField
    }

    func makeCoordinator() -> CustomTF.Coordinator {
        return Coordinator(text: $text)
    }

    // 3
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.borderStyle = .roundedRect
        uiView.keyboardType = keyType
        uiView.placeholder = placeholder
        uiView.font = UIFont(name: "AppleSDGothicNeo-Semibold", size: fontSize)
//        uiView.textColor = UIColor(.blue)
        uiView.textAlignment = .center
    }

    // 4
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.textColor = UIColor(.blue)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            textField.textColor = .label
        }
    }
}



extension  UITextField{
   @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
      self.resignFirstResponder()
   }
   
}
