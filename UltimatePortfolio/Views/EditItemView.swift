//
//  EditItemView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 11/5/20.
//

import SwiftUI
import PreviewDevice

// $property is a
// binding or projected value of property
struct EditItemView: View {
    let item: Item

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Basic settings", comment: ""))) {
                TextField("Item name", text: $title.onChange(self.update))
                TextField("Description", text: $detail.onChange(self.update))
            }

            Section(header: Text(NSLocalizedString("Priority", comment: ""))) {
                Picker("Priority", selection: $priority.onChange(self.update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(self.update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: save)
    }

    func update() {
        self.item.project?.objectWillChange.send()

        self.item.title = self.title
        self.item.detail = self.detail
        self.item.priority = Int16(self.priority)
        self.item.completed = self.completed
    }

    func save() {
        self.dataController.update(item)
    }
}

// https://github.com/Toni77777/PreviewDevice
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
            .previewDevice(device: .iphone12Mini)
    }
}
