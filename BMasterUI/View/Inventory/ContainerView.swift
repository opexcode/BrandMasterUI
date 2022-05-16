//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct ContainerView: View {
    
    @State var title: String
    @State var items: [ContainerItem]
    @State var color: Color
    
    @State private var addContainer = false
    
    var body: some View {
        VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        Text(title)
                            .fontWeight(.medium)
                            .font(.title2)
                        
                        Spacer()
                    }
                    
                    Button(action: {
//                        showEditor.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                
                // Рукава
                VStack {
                    ForEach(items, id: \.self) { item in
                        ItemRowView(item: item)
                    }
                } // VStack
            }
            .padding()
        } // VStack
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(color.opacity(0.5), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
    }
}

struct ItemRowView: View {
    @State var item: ContainerItem
    
    
    var body: some View {
        HStack {
            Text(item.name)
            Text(String(item.amount))
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(title: "Кабина", items: [
            ContainerItem(name: "Ствол А", amount: 10),
            ContainerItem(name: "Ствол В", amount: 7),
            ContainerItem(name: "ФОС", amount: 10),
            ContainerItem(name: "Журнал", amount: 4)
        ], color: .blue)
    }
}
