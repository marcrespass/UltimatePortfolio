//
//  AwardsView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 11/20/20.
//

import SwiftUI
import PreviewDevice

struct AwardsView: View {
    static let tag: String? = "Awards"

    @EnvironmentObject var dataController: DataController
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }

    var body: some View {
        StackNavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            self.selectedAward = award
                            self.showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(Text(award.description))
                        .buttonStyle(ImageButtonStyle())
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(isPresented: $showingAwardDetails) { self.getAwardAlert() }
    }

    func getAwardAlert() -> Alert {
        if dataController.hasEarned(award: self.selectedAward) {
            return Alert(title: Text("Unlocked: \(selectedAward.name)"),
                         message: Text(selectedAward.description),
                         dismissButton: .default(Text("OK")))
        } else {
            return Alert(title: Text("Locked"),
                         message: Text(selectedAward.description),
                         dismissButton: .default(Text("OK")))
        }
    }

    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5)
    }

    func label(for award: Award) -> Text {
        Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        AwardsView()
            .previewDevice(device: .iphone12Mini, colorSchemes: [.light, .dark])
            .environmentObject(self.dataController)
    }
}
