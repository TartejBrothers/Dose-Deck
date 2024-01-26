//
//  NewMed.swift
//  Dose Deck
//
//  Created by Taranjeet Singh Bedi on 27/01/24.
//

import SwiftUI

struct NewMed: View {
    @EnvironmentObject var datamanager: DataManager
    @State private var newmed = ""
    @State private var newhours: Int?
    @State private var newminutes: Int?

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Add Medicine and Time")
            TextField("Medicine", text: $newmed)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.0)
                )

            TextField("Hours", value: $newhours, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.0)
                )

            TextField("Minutes", value: $newminutes, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.0)
                )

            Button {
                // Handle button action
            } label: {
                Text("Save")
                    .frame(width: 100, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(.black))
                    )
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)

    }
}

#Preview {
    NewMed()
}
