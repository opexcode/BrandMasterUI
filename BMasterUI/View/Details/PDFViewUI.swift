//
//  PDFView.swift
//  BMaster
//
//  Created by Алексей on 06.03.2021.
//

import SwiftUI
import PDFKit

struct PDFViewUI: UIViewRepresentable {
	
	var data: Data?
    
	init(data: Data) {
		self.data = data
	}

	func makeUIView(context: Context) -> UIView {
		let pdfView = PDFView()

		if let data = data {
			pdfView.document = PDFDocument(data: data)
			pdfView.autoScales = true
		}

		return pdfView
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		// Empty
	}

}
