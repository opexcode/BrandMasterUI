//
//  CustomNavigationView.swift
//  BMasterUI
//
//  Created by OREKHOV ALEXEY on 02.11.2021.
//

import SwiftUI

struct CustomNavigationView: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return CustomNavigationView.Coordinator(parent: self)
    }
    
    var view: Info
    
    var onSearch: (String) -> ()
    var onCancel: () -> ()
    
    // requre closure on Call...
    init(view: Info, onSearch: @escaping (String) -> (), onCancel: @escaping () ->()) {
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let childView = UIHostingController(rootView: view)
        let controller = UINavigationController(rootViewController: childView)
        
        // Nav Bar Data...
        controller.navigationBar.topItem?.title = "Инфо"
        controller.navigationBar.prefersLargeTitles = true
        
        // Search bar...
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск..."
        
        // setting delegate...
        searchController.searchBar.delegate = context.coordinator
         
        searchController.obscuresBackgroundDuringPresentation = false
        
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context contex: Context) {
        // Update real time...
//        uiViewController.navigationBar.topItem?.title = title
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        var parent: CustomNavigationView
        
        init(parent: CustomNavigationView) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // when text changes...
            self.parent.onSearch(searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // when cancel button is clicked...
            self.parent.onCancel()
        }
    }
    
}

