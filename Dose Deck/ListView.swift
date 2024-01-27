// ListView.swift
import SwiftUI
import Firebase
import UserNotifications

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
                                            if newValue {
                                                scheduleNotification(for: meds)
                                            }
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

    func scheduleNotification(for meds: DataType) {
        let content = UNMutableNotificationContent()
        content.title = "Time for Medicine: \(meds.medicine)"
        content.body = "Take your medicine now."

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        dateComponents.hour = meds.hours
        dateComponents.minute = meds.minutes

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(userIsLogged: .constant(true))
            .environmentObject(DataManager())
    }
}
