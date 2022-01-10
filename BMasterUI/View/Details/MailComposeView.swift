//
//  MailView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 10.01.2022.
//

import SwiftUI
import UIKit
import MessageUI

struct MailComposeView: UIViewControllerRepresentable {
    
    var didFinish: ()->()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeView>) -> MFMailComposeViewController {
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients(["bmasterfire@gmail.com"])
        mail.setSubject("BrandMaster")
        
        return mail
    }
    
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: MailComposeView
        
        init(_ mailController: MailComposeView) {
            self.parent = mailController
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.didFinish()
            controller.dismiss(animated: true)
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeView>) {
        
    }
}
