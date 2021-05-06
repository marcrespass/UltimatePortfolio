//
//  ItemRowViewModel.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 5/6/21.
//

import Foundation
import SwiftUI

extension ItemRowView {
    class ViewModel: ObservableObject {
        let project: Project
        let item: Item

        init(project: Project, item: Item) {
            self.project = project
            self.item = item
        }

        var title: String {
            item.itemTitle
        }
        
        var icon: String {
            if item.completed {
                return SFSymbol.checkmarkCircle.rawValue
            } else if item.priority == 3 {
                return SFSymbol.exclamationmarkTriangle.rawValue
            } else {
                return SFSymbol.checkmark.rawValue
            }
        }

        var color: String? {
            if item.completed {
                return project.projectColor
            } else if item.priority == 3 {
                return project.projectColor
            } else {
                return nil
            }
        }

        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed."
            } else if item.priority == 3 {
                return "\(item.itemTitle), high priority."
            } else {
                return item.itemTitle
            }
        }

    }
}
