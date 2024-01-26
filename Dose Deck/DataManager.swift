import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var med: [DataType] = []
    init (){
        fetchData()
    }
    func fetchData() {
        med.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("DataType")

        ref.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("No data available")
                return
            }

            print("Snapshot documents count: \(snapshot.documents.count)")

            for document in snapshot.documents {
                let data = document.data()
                if
                    let id = data["id"] as? String,
                    let medicine = data["medicine"] as? String,
                    let hours = data["hours"] as? Int,
                    let minutes = data["minutes"] as? Int ,
                    let isSelected = data["isSelected"] as? Bool {
                    let meds = DataType(id: id, medicine: medicine, hours: hours, minutes: minutes, isSelected: isSelected)
                    self.med.append(meds)
                }
            }

            print("Fetched \(self.med.count) medicines")
        }
    }



}
