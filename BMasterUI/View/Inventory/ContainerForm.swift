//
//  AddContainerForm.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import CoreData
import SwiftUI

let colors: [Color] = [.blue, .red, .green, .orange, .yellow, .gray, .pink, .black]
let colorsGrid = [GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible()),
                  GridItem(.flexible())]



struct ContainerForm: View {
    
    @Environment(\.presentationMode) var presentaionMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var colorHeight: CGFloat = 0
    @State private var currentColor: Color = .green
    
    var container: Container?
    @State var masterId: UUID
    @State private var ownID: UUID?
    
    init(id: UUID, container: Container? = nil) {
        self.container = container
        _masterId  = State(initialValue: id)
        let containerID = container == nil ? UUID() : container?.ownID
        _ownID = State(initialValue: containerID)
        
//        if let container = container, let data = container.color, let uiColor = UIColor.color(data: data) {
//            _currentColor = State(initialValue: Color(uiColor))
//        }
    }

    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                // Top
                HStack {
                    Button("Close") {
                        presentaionMode.wrappedValue.dismiss()
                        viewContext.rollback()
                    }
                    
                    Spacer()
                    
                    Button(container != nil ? "Сохранить" : "Добавить") { createContainer(object: self.container)
                        presentaionMode.wrappedValue.dismiss()
                    }
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
                
                if let container = container {
                    Button("Delete") {
                        removeContainer(object: container)
                    }.foregroundColor(.red)
                }
                
                // Items
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        withAnimation() {
                            addItemToContainer()
                        }
                    }) {
                        Image(systemName: "plus.app")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    if let ownID = ownID {
                        ItemsView(id: ownID)
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .onAppear() {
            guard let container = container else { return }
            title = container.title ?? ""
//            masterId = container.id!
            
            if let data = container.color, let uiColor = UIColor.color(data: data) {
                print(currentColor == Color(uiColor))
                self.currentColor = Color(uiColor)
            }
        }
    }
    
    // MARK: - Funcs
    
    private func addItemToContainer() {
        let item = Item(context: viewContext)
        item.name = "Item name"
        item.amount = 0
        item.masterID = self.ownID
    }
    
    private func createContainer(object: Container?) {
        if let object = object {
            viewContext.performAndWait {
                object.masterID = self.masterId
                object.title = self.title
                object.color = UIColor(self.currentColor).encode()
            }
        } else {
            let container = Container(context: viewContext)
            container.masterID = self.masterId
            container.ownID = self.ownID
            container.title = self.title
            container.color = UIColor(self.currentColor).encode()
        }
        try? viewContext.save()
    }
    
    private func removeContainer(object: Container) {
        presentaionMode.wrappedValue.dismiss()
        
        // Удаляем контейнер
        viewContext.delete(object)
        
        // Удаляем items контейнера
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var fetchContent = try? viewContext.fetch(request)
        fetchContent?.removeAll()
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
}

//struct AddContainerForm_Previews: PreviewProvider {
//    static var previews: some View {
//        AddContainerForm()
//    }
//}


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
    
    private func removeItem(objetct: Item) {
        
    }
    
    private func removeAllItems() {
        
    }
}
