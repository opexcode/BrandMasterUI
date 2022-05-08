//
//  InventoryView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct RepositoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var inventory: FetchedResults<Inventory>
    
    @State private var addInventory = false
    
    var body: some View {
        NavigationView {
            List(inventory, id: \.self) { inventory in
//                NavigationLink(destination: InventoryView(inventory: inventory, title: inventory.name!), label: {
//                    Text(inventory.name ?? "False")
//                })
//                    .padding()
            }
            .sheet(isPresented: $addInventory) {
                AddInventoryForm()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addInventory.toggle()
                    }
                }
            }
        }
    }
}

struct RepositoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContex = DataController()
        RepositoryView()
            .environment(\.managedObjectContext, viewContex.container.viewContext)
    }
}
