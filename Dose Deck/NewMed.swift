import SwiftUI
import UserNotifications

struct NewMed: View {
    @EnvironmentObject var datamanager: DataManager
    @State private var newmed = ""
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var isSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let onAddMed: (DataType) -> Void
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        Text("Add Details").font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                // Taking in inputs
                TextField("Medicine", text: $newmed)
                // Creating Time Picker for Clock
                Section(header: Text("Time")) {
                    HStack {
                        Text("Hours")
                        Spacer()
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 100)
                    }

                    HStack {
                        Text("Minutes")
                        Spacer()
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 100)
                    }
                }
                // Checking if the user wants notification or not
                Section {
                    Toggle("Notification", isOn: $isSelected)
                }
                // Saving the data
                Section {
                    Button("Save") {
                        guard !newmed.isEmpty else {
                            return
                        }

                        let newMed = DataType(
                            id: UUID().uuidString,
                            userId: datamanager.userId ?? "",
                            medicine: newmed,
                            hours: selectedHour,
                            minutes: selectedMinute,
                            isSelected: isSelected
                        )

                        onAddMed(newMed)
                        datamanager.fetchData()

                        if isSelected {
                            dispatchNotification(for: newMed)
                        }

                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.green)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss() // Closing the popup
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                    .imageScale(.large)
            })
            .background(Color(red: 34.0/255.0, green: 40.0/255.0, blue: 49.0/255.0, opacity: 1.0))
        }
    }
    // Adding Notification to the stack
    func dispatchNotification(for meds: DataType) {
        let identifier = UUID().uuidString
        let title = "Time for Medicine: \(meds.medicine)"
        let body = "Take your medicine now."

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = selectedHour
        dateComponents.minute = selectedMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct NewMed_Previews: PreviewProvider {
    static var previews: some View {
        NewMed(onAddMed: { _ in })
            .environmentObject(DataManager())
    }
}
