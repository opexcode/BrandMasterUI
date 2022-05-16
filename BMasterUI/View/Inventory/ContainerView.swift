//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct ContainerView: View {
    
    @State var title: String
    //    @State var items: [ContainerItem]
    @State var color: Color
    
    @State private var addContainer = false
    @FetchRequest(
        sortDescriptors: [],
        predicate: nil
    ) var items: FetchedResults<Item>
    
    @Environment(\.colorScheme) var colorScheme
    var backColor: some View {
        colorScheme == .dark ? darkColor : Color.white
    }
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    
                    Text(title)
                        .fontWeight(.medium)
                        .font(.title2)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.gray)
                    }
                }
                
                VStack {
                    ForEach(items, id: \.self) { item in
                        ItemRowView(item: item)
                    }
                }
            }
            .padding()
        } // VStack
        
        .background(backColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.5), lineWidth: 1)
            
        )
        .frame(maxWidth: .infinity)
    }
}

struct ItemRowView: View {
    @State var item: Item
    
    var body: some View {
        HStack {
//            TextField("", text: $item.name)
            Text(item.name!)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
