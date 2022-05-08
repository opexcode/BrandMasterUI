//
//  ContainerView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 19.03.2022.
//

import SwiftUI

struct InventoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var inventory: FetchedResults<Container>
    
    @State var title: String
    
    var body: some View {
        NavigationView {
            Text("")
            
                .navigationTitle(title)
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView(title: "Рукава")
    }
}

