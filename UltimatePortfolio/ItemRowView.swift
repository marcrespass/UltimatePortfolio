//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 11/5/20.
//

import SwiftUI

struct ItemRowView: View {
   @ObservedObject var item: Item // someone else owns this and I am observing it
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
    }
}
