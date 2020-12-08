//
//  ProjectHeaderView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 11/6/20.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack {
                Text(self.project.projectTitle)

                ProgressView(value: self.project.completionAmount)
                    .accentColor(Color(project.projectColor))
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: self.project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(10)
        .accessibilityElement(children: .combine) // combines all items into one
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
