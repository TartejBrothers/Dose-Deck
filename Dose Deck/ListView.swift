import SwiftUI
import Firebase
import UserNotifications

struct ListView: View {
    @EnvironmentObject var datamanager: DataManager
    @Binding var userIsLogged: Bool
    let userId: String
    @State private var showPopup = false
    @State private var dataLoaded = false

    var body: some View {
        NavigationView {
            VStack {
                if datamanager.med.isEmpty {
                    Text("No medicine available")
                } else {
                    List {
                        ForEach(datamanager.med.filter { $0.userId == Auth.auth().currentUser?.uid }) { meds in
                            HStack {
                                Toggle(isOn: Binding(
                                    get: {
                                        if let index = getIndex(for: meds), index < datamanager.med.count {
                                            return datamanager.med[index].isSelected
                                        }
                                        return false
                                    },
                                    set: { newValue in
                                        if let index = getIndex(for: meds), index < datamanager.med.count {
                                            datamanager.updateSelection(for: meds, isSelected: newValue)
                                            if !newValue {
                                                cancelNotification(for: meds)
                                            }
                                        }
                                    }
                                )) {
                                    VStack(alignment: .leading) {
                                        Text("Medicine: \(meds.medicine)")
                                        Text("Time: \(meds.hours):\(meds.minutes)")
                                    }
                                }

                                Spacer()

                                Button(action: {
                                    deleteMedicine(meds)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                if !dataLoaded {
                    datamanager.fetchData()
                    dataLoaded = true
                }
            }
            .navigationBarItems(
                leading: Button(action: {
                    do {
                        try Auth.auth().signOut()
                        userIsLogged = false
                        dataLoaded = false
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    Text("Logout")
                        .padding([.top, .bottom, .trailing], 10)
                        .foregroundColor(.red)
                },
                trailing: Button(action: {
                    showPopup.toggle()
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .padding([.top, .leading, .bottom], 10)
                }
                .sheet(isPresented: $showPopup) {
                    if userIsLogged {
                        NewMed(onAddMed: { newMed in
                            datamanager.addmed(
                                medicine: newMed.medicine,
                                hours: newMed.hours,
                                minutes: newMed.minutes,
                                isSelected: newMed.isSelected
                            )
                            dataLoaded = false
                        })
                    }
                }
            )
        }
    }

    func getIndex(for meds: DataType) -> Int? {
        return datamanager.med.firstIndex { $0.id == meds.id }
    }

    func cancelNotification(for meds: DataType) {
        let identifier = meds.id 
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func deleteMedicine(_ meds: DataType) {
        if let index = getIndex(for: meds) {
            deleteMedFromFirestore(meds)
            datamanager.med.remove(at: index)
        }
    }

    func deleteMedFromFirestore(_ meds: DataType) {
        let db = Firestore.firestore()
        let docRef = db.collection("DataType").document(meds.id)

        docRef.delete { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed from Firestore")
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let userIdForPreview = "UserID"

        return ListView(userIsLogged: .constant(true), userId: userIdForPreview)
            .preferredColorScheme(.dark)
            .environmentObject(DataManager())
    }
}

