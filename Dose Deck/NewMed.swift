//
//  NewMed.swift
//  Dose Deck
//
//  Created by Taranjeet Singh Bedi on 27/01/24.
//

import SwiftUI

struct NewMed: View {
    @ObservedObject var datamanager = DataManager()

    var body: some View {
        VStack {
            if datamanager.med.isEmpty {
                Text("No medicines available")
            } else {
                List {
                    ForEach(datamanager.med) { meds in
                        HStack {
                            Toggle(isOn: $datamanager.med[getIndex(for: meds)].isSelected) {
                                VStack(alignment: .leading) {
                                    Text("Medicine: \(meds.medicine)")
                                    Text("Hours: \(meds.hours)")
                                    Text("Minutes: \(meds.minutes)")
                                }
                            }
                        }
                    }
                }
              
            }

            Button{
                
            } label: {
                Text("Logout")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        
    }

    // Helper function to get the index of a DataType in the array
    private func getIndex(for medicine: DataType) -> Int {
        if let index = datamanager.med.firstIndex(where: { $0.id == medicine.id }) {
            return index
        }
        return 0
    }
}


#Preview {
    NewMed()
}
