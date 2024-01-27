import SwiftUI
import Firebase
import UserNotifications

struct ListView: View {
    @EnvironmentObject var datamanager: DataManager
    @Binding var userIsLogged: Bool
    @State private var showPopup = false
    @State private var dataLoaded = false

    var body: some View {
        checkForPermissions()
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

                                        if newValue {
                                            scheduleNotification(for: meds)
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
    func checkForPermissions() -> some View {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
        return EmptyView()
    }


    func dispatchNotification() {
        let identifier = "morning"
        let title = "Medicine Time"
        let body = "Don't Forget to take medicines on time"
        let hour = 21
        let minute = 10
        let isDaily = true
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let calendar = Calendar.current
        var datecomponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        datecomponents.hour = hour
        datecomponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
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
