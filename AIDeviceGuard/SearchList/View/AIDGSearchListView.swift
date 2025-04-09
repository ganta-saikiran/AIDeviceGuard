//
//  AIDGSearchListView.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 07/04/25.
//

import SwiftUI
import AIComponents
struct AIDGSearchListView: View {
    let title: String
    let items: [String]
    var onSelect: (String) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var filteredItems: [String] {
        if searchText.isEmpty { return items }
        return items.filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search \(title)", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                List(filteredItems, id: \.self) { item in
                    Button(item) {
                        onSelect(item)
                        dismiss()
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}



//#Preview {
//    AIDGSearchListView()
//}
