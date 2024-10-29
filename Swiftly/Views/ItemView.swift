//
//  ItemView.swift
//  Swiftly
//
//  Created by Patrick on 10/28/24.
//

// ItemListView.swift

import SwiftUI

struct ItemView: View {
    @StateObject private var viewModel = ItemViewModel()

    @State private var showUpsertItemSheet = false
    @State private var itemTitle = ""
    @State private var itemDescription = ""
    @State private var selectedItem: Item?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.description)
                            .font(.subheadline)
                        Text("Created at: \(formattedDate(item.createdAt.dateValue()))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle()) // Makes the entire area tappable
                    .onTapGesture {
                        // Set the selected item and show the edit sheet
                        selectedItem = item
                        itemTitle = item.title
                        itemDescription = item.description
                        showUpsertItemSheet = true
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Items")
            // .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ToolbarItem(placement: .principal) {
                //     Text("Items")
                //         .font(.headline)
                //         .fontDesign(.rounded)
                // }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedItem = nil
                        itemTitle = ""
                        itemDescription = ""
                        showUpsertItemSheet = true
                    }) {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .sheet(isPresented: $showUpsertItemSheet) {
            upsertItemSheet
        }
    }

    // Upsert Item Sheet
    private var upsertItemSheet: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $itemTitle)
                TextField("Description", text: $itemDescription)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showUpsertItemSheet = false
                        clearItemFields()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(selectedItem == nil ? "Add Item" : "Edit Item")
                        .font(.headline)
                        .fontDesign(.rounded)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(selectedItem == nil ? "Save" : "Update") {
                        if let item = selectedItem {
                            var updatedItem = item
                            updatedItem.title = itemTitle
                            updatedItem.description = itemDescription
                            viewModel.updateItem(updatedItem)
                        } else {
                            viewModel.addItem(title: itemTitle, description: itemDescription)
                        }
                        showUpsertItemSheet = false
                        clearItemFields()
                    }
                    .disabled(itemTitle.isEmpty)
                }
            }
        }
    }

    // Delete Items
    private func deleteItems(at offsets: IndexSet) {
        offsets.map { viewModel.items[$0] }.forEach { item in
            viewModel.deleteItem(item)
        }
    }

    // Helper Methods
    private func clearItemFields() {
        itemTitle = ""
        itemDescription = ""
        selectedItem = nil
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ItemView()
}
