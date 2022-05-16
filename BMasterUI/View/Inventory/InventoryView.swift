//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct InventoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        predicate: nil
    ) var containers: FetchedResults<Container>
    
    @State var inventory: Inventory
    
    //    init(inventory: Inventory) {
    //        _containers = FetchRequest<Container>(sortDescriptors: [], predicate: NSPredicate(format: "type %@", inventory.type))
    //    }
    
    var body: some View {
        Group {
            if containers.isEmpty {
                EmptyContainer
            } else {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        ForEach(containers, id: \.self) { container in
                            ContainerView(
                                title: container.type!,
                                items: [],
                                color: .blue
                            )
                        }
                    }
                    .padding()
                    .toolbar { ToolbarContent }
                }
            }
        }
        .navigationTitle(inventory.name!)
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
        let container = Container(context: viewContext)
        container.type = "Рукава"
        try? viewContext.save()
    }
}

//struct InventoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryView(inventory: "Рукава")
//    }
//}

