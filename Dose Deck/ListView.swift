//
//  ListView.swift
//  Dose Deck
//
//  Created by Taranjeet Singh Bedi on 26/01/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var datamanager: DataManager

    var body: some View {
        NavigationView {
            if datamanager.med.isEmpty {
                Text("No medicines available")
            } else {
                List(datamanager.med, id: \.id) { meds in
                    VStack(alignment: .leading) {
                        Text("Medicine: \(meds.medicine)")
                        Text("Hours: \(meds.hours)")
                        Text("Minutes: \(meds.minutes)")
                    }
                }

            }
        }.navigationTitle("Medicines")
        

    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environmentObject(DataManager())
    }
}

