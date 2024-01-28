import SwiftUI
import Firebase

class DataManager: ObservableObject {
    // Setting up Notification Variables
    @Published var med: [DataType] = []
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    var userId: String?
    // Fetching the data from Firebase Databse
    init() {
        fetchData()
    }

    func setUserId(_ userId: String) {
        self.userId = userId
    }
    // It checks for the userId is equal to the string value and only returns those collections.
    func fetchData() {
        med.removeAll()
        guard let userId = userId else {
            print("User ID not available")
            return
        }
        // Firestore Setup
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
                // Adding them to the datamanager to view it in the List View
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
    // Function to Add Medicines to the database
    func addmed(medicine: String, hours: Int?, minutes: Int?, isSelected: Bool) {
        guard let userId = userId else {
            print("User ID not available")
            return
        }

        let db = Firestore.firestore()
        let ref = db.collection("DataType").document()
        // Create a reference Schema
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
    // Updating the user notification setting for the Medicine
    func updateSelection(for medicine: DataType, isSelected: Bool) {
        if let index = med.firstIndex(where: { $0.id == medicine.id }) {
            med[index].isSelected = isSelected
        }

        // Update in Firestore
        let db = Firestore.firestore()
        let docRef = db.collection("DataType").document(medicine.id)

        docRef.updateData([
            "isSelected": isSelected
        ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated in Firestore")
            }
        }
    }
    // Notification 
    func showAlert(title: String, message: String) {
           alertTitle = title
           alertMessage = message
           showAlert = true
       }

}

