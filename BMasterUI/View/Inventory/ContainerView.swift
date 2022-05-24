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



