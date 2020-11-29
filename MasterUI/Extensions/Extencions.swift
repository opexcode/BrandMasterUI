//
//  Extencions.swift
//  MasterUI
//
//  Created by Алексей on 27.11.2020.
//

import SwiftUI


// Скрываем клавиатуру
extension View {
	func endEditing(_ force: Bool) {
		UIApplication.shared.windows.forEach { $0.endEditing(force)}
	}
}
