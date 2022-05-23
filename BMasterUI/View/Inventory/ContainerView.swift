//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct ContainerView: View {
    
    @State var container: Container
    
    @State private var presentEditForm = false
    @State private var addContainer = false
    @Environment(\.colorScheme) var colorScheme
    
    var backColor: some View {
        colorScheme == .dark ? darkColor : Color.white
    }
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    
    init(container: Container) {
        _container = State(initialValue: container)
        
        guard let id = container.ownID else { return }
        _items = FetchRequest<Item>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "masterID == %@", id as CVarArg)
        )
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    
                    Text(container.title ?? "")
                        .fontWeight(.medium)
                        .font(.title2)
                    
                    Spacer()
                    
                    Button(action: {
                        presentEditForm.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.gray)
                    }
                }
                
//                ItemsView(id: container.ownID!)
                
                VStack {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item.name ?? "")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Text(String(item.amount))
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 50, alignment: .trailing)
                            
                        }
                        .frame(height: 30)
                    }
                }
            }
            .padding()
        } // VStack
        .background(backColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor.opacity(0.5), lineWidth: 2)
            
        )
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $presentEditForm) {
            ContainerForm(id: self.container.masterID ?? UUID(), container: self.container)
        }
    }
    
    var borderColor: Color {
        if let data = container.color, let uiColor = UIColor.color(data: data) {
            return Color(uiColor)
        } else {
            return .clear
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
            }
            
//            Text(item.name ?? "")
//                .foregroundColor(.gray)
//                .frame(maxWidth: .infinity, alignment: .leading)
            
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
    }
    
    private func editItem(object: Item) {
        viewContext.performAndWait {
            object.name = item.name
            object.amount = item.amount
        }
        try? viewContext.save()
    }
}

//
//struct ContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContainerView(
//            title: "Кабина",
//            color: .blue,
//            items: [
//                ContainerItem(name: "Ствол А", amount: 10),
//                ContainerItem(name: "Ствол В", amount: 7),
//                ContainerItem(name: "ФОС", amount: 10),
//                ContainerItem(name: "Журнал", amount: 4)
//            ])
//        .padding()
//    }
//}
