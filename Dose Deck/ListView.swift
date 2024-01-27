import SwiftUI
import Firebase

struct ListView: View {
    @EnvironmentObject var datamanager: DataManager
    @Binding var userIsLogged: Bool
    @State private var redirectToLogin = false
    @State private var showPopup = false

    var body: some View {
        NavigationView {
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

                NavigationLink(
                    destination: ContentView(userIsLogged: $userIsLogged),
                    isActive: $redirectToLogin,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
                Button(action: {
                    showPopup.toggle()
                }){
                    Text("Add Item")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        userIsLogged = false
                        redirectToLogin = true
                        
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }){
                    Text("Logout")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .sheet(isPresented: $showPopup) {
                            NewMed()
                        }
                }
            }
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
