//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 12/9/20.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    let items: ArraySlice<Item>

    fileprivate func itemCard(item: Item) -> some View {
        HStack(spacing: 20) {
            Circle()
                .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                .frame(width: 44, height: 44)
            VStack {
                Text("\(item.itemTitle) - \(item.project?.projectTitle ?? "")")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if item.itemDetail.isEmpty == false {
                    Text(item.itemDetail)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    var body: some View {
        if !items.isEmpty {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    itemCard(item: item)
                        .padding()
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        } else {
            EmptyView()
        }
    }
}
