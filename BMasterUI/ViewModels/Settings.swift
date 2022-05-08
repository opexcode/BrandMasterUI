//
//  Settings.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 07.01.2022.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("fontSize") var fontSize: Int = 17
}
