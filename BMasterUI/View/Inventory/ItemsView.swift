//
//  ItemsView.swift
//  BMasterUI
//
//  Created by   imac on 23.05.2022.
//

import SwiftUI

struct ItemsView: View {
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @State var id: UUID
    
    init(id: UUID) {
        _id = State(initialValue: id)
        _items = FetchRequest<Item>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "masterID == %@", id as CVarArg)
        )
    }
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            ItemRowView(item: item)
        }
    }
    
}

struct ItemRowView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    
    var body: some View {
        HStack {
            if let name = Binding($item.name) {
                TextField("Title", text: name)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .intro
            }
            
            Spacer()
            
            Text(String(item.amount))
                .font(.system(size: 18, weight: .bold))
                .frame(width: 50, alignment: .trailing)
            
            Stepper("") {
                item.amount += 1
            } onDecrement: {
                if item.amount > 0 {
                    item.amount -= 1
                }
            }
            .frame(width: 110)
            
        }
        .onChange(of: item.amount) { newValue in
            if newValue == 0 {
                removeItem(object: self.item)
            }
        }
    }
    
    private func editItem(object: Item) {
        viewContext.performAndWait {
            object.name = item.name
            object.amount = item.amount
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
    private func removeItem(object: Item) {
        withAnimation {
            viewContext.delete(object)
        }
    }
}
