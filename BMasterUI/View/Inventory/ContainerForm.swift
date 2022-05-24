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
    @State private var currentColor: Color = .blue
    
    @State private var presentRemovedAlert: Bool = false
    
    var container: Container?
    @State var masterId: UUID
    @State private var ownID: UUID?
    
    init(id: UUID, container: Container? = nil) {
        self.container = container
        _masterId  = State(initialValue: id)
        let containerID = container == nil ? UUID() : container?.ownID
        _ownID = State(initialValue: containerID)
    }

    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                // Top
                HStack {
                    Button(action: {
                        presentaionMode.wrappedValue.dismiss()
                        viewContext.rollback()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if !title.isEmpty {
                            createContainer(object: self.container)
                            presentaionMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    
//                    HStack {
//                        Button(container != nil ? "Сохранить" : "Добавить") {
//                            if !title.isEmpty {
//                                createContainer(object: self.container)
//                                presentaionMode.wrappedValue.dismiss()
//                            }
//                        }
//                        Image(systemName: "checkmark")
////                            .resizable()
////                            .frame(width: 18, height: 18)
//                    }
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
                    Text("Цвет")

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
                                    
                                    if currentColor == color {
                                        Image(systemName: "checkmark.circle")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .scaledToFit()
                                            .frame(width: 25)
                                    }
                                } // ZStack
                            } // Button
                        } // ForEach
                    } // LazyVGrid
                }
                
                if container != nil {
                    Button(action: {
                        presentRemovedAlert.toggle()
                    }) {
                        HStack {
                            Text("Удалить контейнер")
                            Image(systemName: "trash")
                        }
                        .foregroundColor(.red)
                    }
                }
                
                // Items
                VStack(alignment: .leading, spacing: 15) {
                    Button(action: {
                        withAnimation() {
                            addItemToContainer()
                        }
                    }) {
                        HStack {
                            Text("Добавить содержимое")
                            Image(systemName: "plus")
                        }
                    }
                    
                    if let ownID = ownID {
                        ItemsView(id: ownID)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(currentColor.opacity(0.5), lineWidth: 2)
                )
                
            }
            .padding(.horizontal)
        }
        .onAppear() {
            guard let container = container else { return }
            title = container.title ?? ""
            currentColor = borderColor
        }
        
        .alert(isPresented: $presentRemovedAlert) {
            Alert(
                title: Text("Удалить контейнер?"),
                primaryButton: .default(Text("OK"), action: {
                    if let container = container {
                        removeContainer(object: container)
                    }
                }),
                secondaryButton: .cancel(Text("Отмена")) {
                    presentRemovedAlert = false
                })
        }
    }
    
    var borderColor: Color {
        if let container = container, let data = container.color, let uiColor = UIColor.color(data: data) {
            return Color(uiColor)
        } else {
            return .blue
        }
    }
    
    // MARK: - Funcs
    
    private func addItemToContainer() {
        let item = Item(context: viewContext)
        item.name = "Редактировать"
        item.amount = 1
        item.masterID = self.ownID
        item.timestamp = Date()
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
            container.timestamp = Date()
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

