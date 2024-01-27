import SwiftUI
import Firebase

struct ListView: View {
    @EnvironmentObject var datamanager: DataManager
    @Binding var userIsLogged: Bool
    @State private var showPopup = false
    @State private var dataLoaded = false

    var body: some View {
        NavigationView {
            VStack {
                if datamanager.med.isEmpty {
                    Text("No medicines available")
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
                                        }
                                    }
                                )) {
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
                if !dataLoaded {
                    datamanager.fetchData()
                    dataLoaded = true
                }
            }
            .onReceive(datamanager.$med) { _ in
                if !dataLoaded {
                    dataLoaded = true
                }
            }
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        showPopup.toggle()
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding([.top, .leading, .bottom], 10)
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
                            dataLoaded = false
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }) {
                        Text("Logout")
                            .padding([.top, .bottom, .trailing], 10)
                    }
                }
            )
        }
    }

    func getIndex(for meds: DataType) -> Int? {
        return datamanager.med.firstIndex { $0.id == meds.id }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(userIsLogged: .constant(true))
            .environmentObject(DataManager())
    }
}
