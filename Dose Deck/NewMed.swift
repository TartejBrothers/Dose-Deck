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
               Text("Add Details")
                   .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                   .foregroundColor(.white)
                   .padding(.bottom,10)
               Text("Medicine")
                   .offset(x:-130)
                   .foregroundColor(.white)
                   .padding(.bottom,-10)
               
               TextField("", text: $newmed)
                   .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                   .foregroundColor(.white)
                   .background(
                       RoundedRectangle(cornerRadius: 25)
                           .stroke(Color.gray, lineWidth: 1.0)
                   )
               Text("Hour Clock")
                   .offset(x:-125)
                   .foregroundColor(.white)
                   .padding(.bottom,-10)
               
               TextField("", value: $newhours, formatter: NumberFormatter())
                   .keyboardType(.numberPad)
                   .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                   .foregroundColor(.white)
                   .background(
                       RoundedRectangle(cornerRadius: 25)
                           .stroke(Color.gray, lineWidth: 1.0)
                   )
               Text("Minute Clock")
                   .offset(x:-117)
                   .foregroundColor(.white)
                   .padding(.bottom,-10)
               TextField("", value: $newminutes, formatter: NumberFormatter())
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
                       .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(.black)))
                    .foregroundColor(.white)
               }
           }
           .frame(maxHeight: .infinity)
           .padding(.horizontal, 20)
           .background(Color(red: 34.0/255.0, green: 40.0/255.0, blue: 49.0/255.0, opacity: 1.0))
           .ignoresSafeArea()
       }
}

#Preview {
    NewMed()
}