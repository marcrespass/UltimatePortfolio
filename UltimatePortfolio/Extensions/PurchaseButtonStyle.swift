//
//  PurchaseButton.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 5/27/21.
//

import SwiftUI

struct PurchaseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 44)
            .background(Color("Light Blue"))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct PurchaseButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("Purchase") {
            print("purchased")
        }
        .preferredColorScheme(.dark)
        .buttonStyle(PurchaseButtonStyle())
    }
}
