//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct InventoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var containers: FetchedResults<Container>
    
    @ObservedObject var inventory: Inventory
    @State private var presentAddContainerForm = false
    @State private var editInventoryName = false
    
    init(inventory: Inventory) {
        _inventory = ObservedObject(initialValue: inventory)
        
        guard let id = inventory.id else { return }
        _containers = FetchRequest<Container>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "masterID == %@", id as CVarArg)
        )
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            Group {
                if containers.isEmpty {
                    EmptyContainer
                } else {
                    ScrollView(.vertical) {
                        VStack(spacing: 10) {
                            ForEach(containers, id: \.self) { container in
                                ContainerView(container: container)
                            }
                        }
                        .padding()
                        .toolbar { ToolbarContent }
                    }
                }
            }
            .navigationTitle(inventory.name ?? "")
        }
        .fullScreenCover(isPresented: $presentAddContainerForm) {
            ContainerForm(id: inventory.id ?? UUID())
        }
        
        .overlay(customSheetBackground)
        .textFieldAlert(
            isShowing: $editInventoryName,
            text: Binding($inventory.name)!,
            title: "Новый инвентарь",
            action: {})
    }
    
    var EmptyContainer: some View {
        VStack(spacing: 10) {
            Text("Добавить содержимое")
            
            Button(action: createContainer) {
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
                presentAddContainerForm.toggle()
            }) {
                Image(systemName: "plus.app.fill")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                withAnimation {
                    editInventoryName.toggle()
                }
            }) {
                Image(systemName: "pencil")
            }
        }
    }
    
    @ViewBuilder
    var customSheetBackground: some View {
        if editInventoryName {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { editInventoryName.toggle() }
        }
    }
    
    
    // MARK: - Funcs
    private func createContainer() {
        presentAddContainerForm.toggle()
    }
}

//struct InventoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryView(inventory: "Рукава")
//    }
//}

