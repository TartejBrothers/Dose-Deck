import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var med: [DataType] = []

    init() {
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
                let id = document.documentID
                if
                    let medicine = data["medicine"] as? String,
                    let isSelected = data["isSelected"] as? Bool,
                    let hours = data["hours"] as? Int? ?? 0, 
                    let minutes = data["minutes"] as? Int? ?? 0 {

                    let meds = DataType(id: id, medicine: medicine, hours: hours, minutes: minutes, isSelected: isSelected)
                    self.med.append(meds)
                }
            }

            print("Fetched \(self.med.count) medicines")
        }
    }





    func addmed(medicine: String, hours: Int?, minutes: Int?, isSelected: Bool) {
        let db = Firestore.firestore()
        let ref = db.collection("DataType").document()

        ref.setData([
            "id": ref.documentID,
            "medicine": medicine,
            "hours": hours as Any?,
            "minutes": minutes as Any?,
            "isSelected": isSelected
        ], merge: true) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}
