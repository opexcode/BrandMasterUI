//
//  AddInventoryForm.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct AddInventoryForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentaionMode
    
    @State private var name = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    Button("Close") {
                        presentaionMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                    Button("Add") {
                        let container = Inventory(context: viewContext)
                        container.name = name
                        
                        try? viewContext.save()
                        presentaionMode.wrappedValue.dismiss()
                    }
                }
                .frame(height: 50)
                
                Text("Новый инвентарь")
                    .font(.system(size: 18, weight: .semibold))
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
        }
    }
}

struct AddInventoryForm_Previews: PreviewProvider {
    static var previews: some View {
        AddInventoryForm()
    }
}
