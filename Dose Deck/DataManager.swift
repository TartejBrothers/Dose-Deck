import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var med: [DataType] = []
    var userId: String?

    init() {
        fetchData()
    }

    func setUserId(_ userId: String) {
        self.userId = userId
    }

    func fetchData() {
        med.removeAll()
        guard let userId = userId else {
            print("User ID not available")
            return
        }

        let db = Firestore.firestore()
        let ref = db.collection("DataType").whereField("userId", isEqualTo: userId)

        ref.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("No data available")
                return
            }

            for document in snapshot.documents {
                let data = document.data()
                let id = document.documentID

                if
                    let medicine = data["medicine"] as? String,
                    let isSelected = data["isSelected"] as? Bool,
                    let hours = data["hours"] as? Int? ?? 0,
                    let minutes = data["minutes"] as? Int? ?? 0 {

                    let meds = DataType(id: id, userId: userId, medicine: medicine, hours: hours, minutes: minutes, isSelected: isSelected)
                    self.med.append(meds)
                }
            }

            print("Fetched \(self.med.count) medicines")
        }
    }

    func addmed(medicine: String, hours: Int?, minutes: Int?, isSelected: Bool) {
        guard let userId = userId else {
            print("User ID not available")
            return
        }

        let db = Firestore.firestore()
        let ref = db.collection("DataType").document()

        ref.setData([
            "id": ref.documentID,
            "medicine": medicine,
            "hours": hours as Any?,
            "minutes": minutes as Any?,
            "isSelected": isSelected,
            "userId": userId
        ], merge: true) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func updateSelection(for meds: DataType, isSelected: Bool) {
        if let index = med.firstIndex(where: { $0.id == meds.id }) {
            med[index].isSelected = isSelected
        }
    }
}

