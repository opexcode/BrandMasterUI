//
//  InventoryView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct RepositoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [.init(key: "timestamp", ascending: false)]) var inventories: FetchedResults<Inventory>
    @FetchRequest(sortDescriptors: []) var containers: FetchedResults<Container> // test
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item> // test
    
    @State private var presentAddInventorySheet = false
    @State private var presentRemoveAllAlert = false
    
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
        .onChange(of: presentAddInventorySheet, perform: { newValue in
            // Очищаем залоловок при создании нового инветаря
            if newValue { inventoryName = "" }
        })
        .overlay(customSheetBackground)
        
        .textFieldAlert(
            isShowing: $presentAddInventorySheet,
            text: $inventoryName,
            title: "Новый инвентарь",
            action: addInventory)
        
        .alert(isPresented: $presentRemoveAllAlert) {
            Alert(
                title: Text("Удалить все?"),
                primaryButton: .default(Text("OK"), action: {
                    removeAll()
                }),
                secondaryButton: .cancel(Text("Отмена")) {
                    presentRemoveAllAlert = false
                })
        }
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
            Button(action: {
                withAnimation { presentAddInventorySheet.toggle() }
            }) {
                Image(systemName: "plus")
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                withAnimation { presentRemoveAllAlert.toggle() }
            }) {
                Image(systemName: "trash")
            }
        }
    }
    
    @ViewBuilder
    var customSheetBackground: some View {
        if presentAddInventorySheet {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    // MARK: Funcs
    private func addInventory() {
        if !inventoryName.isEmpty {
            let inventory = Inventory(context: viewContext)
            inventory.id = UUID()
            inventory.name = inventoryName
            
            try? viewContext.save()
            presentAddInventorySheet.toggle()
        }
    }
    
    private func removeAll() {
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

struct RepositoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContex = DataController()
        RepositoryView()
            .environment(\.managedObjectContext, viewContex.container.viewContext)
    }
}

