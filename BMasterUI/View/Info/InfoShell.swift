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
        CustomNavigationView(
            view: Info(filteredItems: $filteredItems, showSearch: $showSearch),
            onSearch: { txt in
            
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
        List(filteredItems, id: \.self) { query in
            NavigationLink(destination: TextViewer(text: search.getContent(by: query))) {
                Image(systemName: "􀊫")
                Text(query)
            }
        }
    }
    
    var MainMenu: some View {
        List {
            Section {
                menuRowItem(destination: { MarksView() },
                            image: "􀉞", title: "Примечания к формулам")
                
                menuRowItem(destination: { InstructionsView() },
                            image: "􀈕", title: "Обязаности")
                
                menuRowItem(destination: { SmokeServiceView() },
                            image: "􀈕", title: "ГДЗС")
                
                menuRowItem(destination: { Leader() },
                            image: "􀈕", title: "РТП")
                
                menuRowItem(destination: { Devices() },
                            image: "􀣋", title: "ТТХ СИЗОД")
            }
            
            Section(header: Text(""), footer: FooterView()) {
                
                HStack {
                    Image(systemName: "􀠃")
                    Link("БрандМастер в VK", destination: URL(string: "https://vk.com/brmeister")!)
                }
                
                HStack {
                    Image(systemName: "􀣺")
                    Link("Оценить БрандМастер", destination: URL(string: "https://apps.apple.com/ru/app/id1508823670")!)
                }
                
                
                HStack {
                    Image(systemName: "􀅷")
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
    
//    @ViewBuilder
    func menuRowItem<Content>(destination: @escaping () -> Content, image: String, title: String) -> some View where Content: View {
        NavigationLink(destination: destination) {
            Image(systemName: image)
            Text(title)
        }
        
    }
    
}


// MARK: - Footer
struct FooterView: View {
    let appVersion = Bundle.main.versionNumber
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 5) {
                HStack(spacing: 5) {
                    Text("БрандМастер - ГДЗС")
                }
                
                Text(verbatim: "Версия: \(appVersion ?? "1.0")")
                Text("Alexey Orekhov")
            }
            Spacer()
        }
        .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
        .padding()
    }
}

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    var bundleName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}
