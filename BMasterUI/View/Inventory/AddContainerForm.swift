//
//  AddContainerForm.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct AddContainerForm: View {
    @Environment(\.presentationMode) var presentaionMode
    @Environment(\.managedObjectContext) private var viewContext
    
    let colors: [Color] = [.blue, .red, .green, .orange, .yellow, .gray, .pink, .black]
    let colorsGrid = [GridItem(.flexible()),
                      GridItem(.flexible()),
                      GridItem(.flexible()),
                      GridItem(.flexible()),
                      GridItem(.flexible()),
                      GridItem(.flexible())]
    
    @State private var colorHeight: CGFloat = 0
    @State private var title: String = ""
    @State private var currentColor: Color = .clear
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    var container: Container?
    @State var id: UUID
    
    init(id: UUID, container: Container? = nil) {
        self.container = container
        _id  = State(initialValue: id)
        _items = FetchRequest<Item>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", id as CVarArg)
        )
    }

    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    Button("Close") {
                        presentaionMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                    
                    Button("Add") { createContainer(object: self.container) }
                }
                .frame(height: 50)
                
                // Title
                VStack(alignment: .leading, spacing: 10) {
                    Text("Название")
                    TextField("", text: $title)
                        .textFieldStyle(.roundedBorder)
                }

                // Color
                VStack(alignment: .leading, spacing: 10) {
                    Text("Выбери цвет")
                    
                    LazyVGrid(columns: colorsGrid) {
                        ForEach(colors, id: \.self) { color in
                            Button(action: {
                                currentColor = color
                            }) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(color)
                                        .overlay(
                                            GeometryReader { g in
                                                Color.clear.onAppear { colorHeight = g.size.width }
                                            }
                                        )
                                        .frame(height: colorHeight)
                                        .cornerRadius(6)
                                    
                                    if color == currentColor {
                                        Image(systemName: "checkmark.circle")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .scaledToFit()
                                            .frame(width: 25)
                                    }
                                } // ZStack
                            } // ButtonЯ
                        } // ForEach
                    } // LazyVGrid
                }
                
                // Items
                VStack(alignment: .leading, spacing: 10) {
                    Button("Add Item") {
                        addItemToContainer()
                    }
                    
                    ForEach(items, id: \.self) { item in
                        ItemRowView(item: item)
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .onAppear() {
            guard let container = container else { return }
            title = container.title ?? ""
            id = container.id!
//            currentColor = container.color
        }
    }
    
    // MARK: - Funcs
    
    private func addItemToContainer() {
        let item = Item(context: viewContext)
        item.name = "Item name"
        item.amount = 0
        item.id = self.id
        
        try? viewContext.save()
    }
    
    private func createContainer(object: Container?) {
        if let object = object {
            viewContext.performAndWait {
                object.id = self.id
                object.title = self.title
            }
        } else {
            let container = Container(context: viewContext)
            container.id = self.id
            container.title = title
            print("Container id \(container.id)")
        }
        try? viewContext.save()
        presentaionMode.wrappedValue.dismiss()
        
    }
}

//struct AddContainerForm_Previews: PreviewProvider {
//    static var previews: some View {
//        AddContainerForm()
//    }
//}
