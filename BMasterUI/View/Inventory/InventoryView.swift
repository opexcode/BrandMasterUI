//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct InventoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var containers: FetchedResults<Container>
    
    @State var inventory: Inventory
    @State private var presentAddContainerForm = false
    
    init(inventory: Inventory) {
        _inventory = State(initialValue: inventory)
//        guard let id = inventory.id else {
//            print("false inventory.id")
//            return
//        }
        print("\(inventory.id!)")
        _containers = FetchRequest<Container>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", inventory.id! as CVarArg)
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
        .sheet(isPresented: $presentAddContainerForm) {
            AddContainerForm(id: inventory.id ?? UUID())
        }
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
            Button(action: createContainer) {
                Image(systemName: "plus.app.fill")
            }
        }
    }
    
    
    // MARK: - Funcs
    private func createContainer() {
        presentAddContainerForm.toggle()
//        let container = Container(context: viewContext)
//        container.type = "Рукава"
//        try? viewContext.save()
    }
}

//struct InventoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryView(inventory: "Рукава")
//    }
//}

