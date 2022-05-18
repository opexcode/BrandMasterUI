//
//  InventoryView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct RepositoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var inventories: FetchedResults<Inventory>
    @FetchRequest(sortDescriptors: []) var containers: FetchedResults<Container> // test
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item> // test
    
    @State private var presentAddInventorySheet = false
    
    @State private var inventoryName = ""
    
    
    var body: some View {
        NavigationView {
            Group {
                if inventories.isEmpty {
                    EmptyInventory
                } else {
                    List(inventories, id: \.self) { inventory in
                        NavigationLink(
                            destination: InventoryView(inventory: inventory),
                            label: {
                                Text(inventory.name ?? "False")
                            })
                    }
                    .toolbar { ToolbarContent }
                }
            }
        }
        
        .overlay(customSheetBackground)
        .textFieldAlert(
            isShowing: $presentAddInventorySheet,
            text: $inventoryName,
            title: "Новый инвентарь",
            action: addInventory) 
        
    }
    
    
    var EmptyInventory: some View {
        VStack(spacing: 10) {
            Text("Добавить инвентарь")
            
            Button(action: {
                withAnimation {
                    presentAddInventorySheet.toggle()
                }
            }) {
                Image(systemName: "plus.square")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    @ToolbarContentBuilder
    var ToolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Add") {
                withAnimation {
                    presentAddInventorySheet.toggle()
                }
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Remove All") {
                inventories.forEach { item in
                    viewContext.delete(item)
                }
                containers.forEach { item in
                    viewContext.delete(item)
                }
                items.forEach { item in
                    viewContext.delete(item)
                }
                
                try? viewContext.save()
            }
        }
    }
    
    @ViewBuilder
    var customSheetBackground: some View {
        if presentAddInventorySheet {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    print("toggle")
                    presentAddInventorySheet.toggle()
                }
        }
    }
    
    // MARK: Funcs
    private func addInventory() {
        let inventory = Inventory(context: viewContext)
        inventory.id = UUID()
        inventory.name = inventoryName
        print("Create \(inventory.id)")
        try? viewContext.save()
        presentAddInventorySheet.toggle()
    }
}

struct RepositoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContex = DataController()
        RepositoryView()
            .environment(\.managedObjectContext, viewContex.container.viewContext)
    }
}

