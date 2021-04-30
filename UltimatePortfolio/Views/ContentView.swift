//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 10/26/20.
//

import SwiftUI

/*
 The problem with optionals
 we want selectedView to be an optional String so that it can be nil
 when we start but now SwiftUI is comparing Optional<String> to String
 and they can never be equal (!)
 Thus we will change our static tags to be optional and set a value
 and now they can be compared
 */
struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    SFSymbol.house
                    Text("Home")
                }

            ProjectsView(dataController: dataController, showCloseProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    SFSymbol.listBullet
                    Text("Open")
                }

            ProjectsView(dataController: dataController, showCloseProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    SFSymbol.checkmark
                    Text("Closed")
                }

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    SFSymbol.rosette
                    Text("Awards")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, self.dataController.container.viewContext)
            .environmentObject(self.dataController)
    }
}
