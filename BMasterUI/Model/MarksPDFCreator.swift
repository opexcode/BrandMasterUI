//
//  MarksPDFCreator.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 08.01.2022.
//

import Foundation
import PDFKit

final class MarksPDFCreator: NSObject {
    // Щрифты
    let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 16)!]
    let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]
    let bold = [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 16)!]
    let note = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]

    // PDF
    let format = UIGraphicsPDFRendererFormat()
    let pageWidth = 595.2     // A4 Width
    let pageHeight = 841.8     // A4 Height
    
    // PDF-страница с примечаниями
    func marksViewer() -> Data{
        let pdfMetaData = [
            kCGPDFContextCreator: "Brandmaster",
            kCGPDFContextAuthor: "Aleksey Orekhov"
        ]
        format.documentInfo = pdfMetaData as [String: Any]
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let context = context.cgContext

            // Подставляем PDF шаблон с формулами
            let path = Bundle.main.path(forResource: "PatternForMarks", ofType: "pdf")!
            let url = URL(fileURLWithPath: path)
            let document = CGPDFDocument(url as CFURL)
            // Количество страниц
            let page = document?.page(at: 1)
            UIColor.white.set()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.drawPDFPage(page!)
        }
        return data
    }
}
