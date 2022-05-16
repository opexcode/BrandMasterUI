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
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    
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
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    Button("Close") {
                        presentaionMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                    Button("Add") {
                        let container = Container(context: viewContext)
                        container.type = title

                        try? viewContext.save()
                        presentaionMode.wrappedValue.dismiss()
                    }
                }
                .frame(height: 50)
                
                Text("Название")
                TextField("", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Button("Add Item") {
                    let item = Item(context: viewContext)
                    item.name = "Item name"
                    item.amount = 0
                    
                    try? viewContext.save()
                }
                
                ForEach(items, id: \.self) { item in
                    ItemRowView(item: item)
                }
                
                Spacer(minLength: 40)
                
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
            }
            .padding(.horizontal)
        }
    }
}

struct AddContainerForm_Previews: PreviewProvider {
    static var previews: some View {
        AddContainerForm()
    }
}
