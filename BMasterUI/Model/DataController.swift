//
//  DataController.swift
//  BMasterUI
//
<<<<<<< HEAD
//  Created by   imac on 16.05.2022.
=======
//  Created by OREKHOV ALEXEY on 19.03.2022.
>>>>>>> 71e59b2bafa146df93127f5fba6247cd6e40ba02
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
