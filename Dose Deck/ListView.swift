import SwiftUI
import Firebase

struct ListView: View {
    @EnvironmentObject var datamanager: DataManager
    @Binding var userIsLogged: Bool
    @State private var showPopup = false

    var body: some View {
        NavigationView {
            VStack {
                if datamanager.med.isEmpty {
                    Text("No medicines available")
                } else {
                    List {
                        ForEach(datamanager.med.filter { $0.userId == Auth.auth().currentUser?.uid }) { meds in
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
            }
            .onAppear {
                datamanager.fetchData()
            }
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        showPopup.toggle()
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding()
                    }
                    .sheet(isPresented: $showPopup) {
                        if userIsLogged {
                            NewMed()
                        }
                    }

                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            userIsLogged = false
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }) {
                        Image(systemName: "power")
                            .imageScale(.large)
                            .padding()
                    }
                }
            )
        }
    }

    func getIndex(for meds: DataType) -> Int {
        if let index = datamanager.med.firstIndex(where: { $0.id == meds.id }) {
            return index
        }
        return 0
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(userIsLogged: .constant(true))
            .environmentObject(DataManager())
    }
}
