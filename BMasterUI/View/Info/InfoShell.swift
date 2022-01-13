//
//  InfoView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 02.11.2021.
//

import SwiftUI
import MessageUI


let dict = [
    "командир звена",
    "газодымозащитник",
    "постовой на посту безопасности",
    
    "помощник НК",
    "пнк",
    "командир отделения",
    "пожарный",
    "водитель ПА",
    
    "дежурный по подразделению",
    "дневальный по гаражу",
    "дневальный по помещениям",
    "постовой у фасада",
    
    "обслуживание сизод",
    "правила работы в СИЗОД",
    "звено ГДЗС",
    "пост безопасности",
    
    "минимум оснащения",
    "оснащение звена",
    "ДАСВ",
    
    "5 решающих направлений",
    "ртп",
    "полномочия РТП",
    "оперативный штаб",
    "разведка"
    
]



struct InfoShell: View {
    @State var filteredItems = dict
    @State var showSearch = false
    
    var body: some View {
        CustomNavigationView(view: Info(filteredItems: $filteredItems, showSearch: $showSearch), onSearch: { txt in
            
            // filtering Data...
            if txt != "" {
                self.showSearch = true
                self.filteredItems = dict.filter{$0.lowercased().contains(txt.lowercased())}
            }
            else {
                self.showSearch = false
                self.filteredItems = dict
            }
            
        }, onCancel: {
            // Do your code when search and canceled...
            self.showSearch = false
            self.filteredItems = dict
        })
    }
}


struct Info: View {
    var search = Search()
    @Binding var filteredItems: [String]
    @Binding var showSearch: Bool
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var showingMail: Bool = false
    
    var body: some View {
        if showSearch {
            SearchCompilation
        } else {
            MainMenu
        }
    }
    
    var SearchCompilation: some View {
        List {
            ForEach(filteredItems, id: \.self) { query in
                NavigationLink(destination: TextViewer(text: search.getContent(by: query))) {
                    Image(systemName: "magnifyingglass")
                    Text(query)
                }
            }
        }
    }
    
    var MainMenu: some View {
        List {
            Section {
                NavigationLink(destination: MarksView()) {
                    Image(systemName: "bookmark")
                    Text("Примечания к формулам")
                }
                
                NavigationLink(destination: InstructionsView()) {
                    Image(systemName: "folder")
                    Text("Обязаности")
                }
                
                NavigationLink(destination: SmokeServiceView()) {
                    Image(systemName: "folder")
                    Text("ГДЗС")
                }
                
                NavigationLink(destination: Leader()) {
                    Image(systemName: "folder")
                    Text("РТП")
                }
                
                NavigationLink(destination: Devices()) {
                    Image(systemName: "gearshape")
                    Text("ТТХ СИЗОД")
                }
            }
            
            Section(header: Text(""), footer: FooterView()) {
                
                HStack {
                    Image(systemName: "person.2.circle")
                    Link("БрандМастер в VK", destination: URL(string: "https://vk.com/brmeister")!)
                }
                
                HStack {
                    Image(systemName: "applelogo")
                    Link("Оценить БрандМастер", destination: URL(string: "https://apps.apple.com/ru/app/id1508823670")!)
                }
                
                
                HStack {
                    Image(systemName: "at")
                    Button("Написать разработчику") {
                        showingMail.toggle()
                    }
                    .sheet(isPresented: $showingMail) {
                        MailComposeView() { }
                    }
                }
            }
        }
        .listStyle(InsetListStyle())
        
    }
    
}


// MARK: - Footer
struct FooterView: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 5) {
                HStack(spacing: 5) {
                    Text("БрандМастер - ГДЗС")
                }
                
                Text("Версия: 1.0")
                Text("Alexey Orekhov")
            }
            Spacer()
        }
        .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
        .padding()
    }
}
