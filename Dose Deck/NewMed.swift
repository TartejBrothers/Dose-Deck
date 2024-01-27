import SwiftUI
import UserNotifications

struct NewMed: View {
    @EnvironmentObject var datamanager: DataManager
    @State private var newmed = ""
    @State private var newhours = ""
    @State private var newminutes = ""
    @State private var isSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let onAddMed: (DataType) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Add Details")
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            Text("Medicine")
                .offset(x: -130)
                .foregroundColor(.white)
                .padding(.bottom, -10)

            TextField("", text: $newmed)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.0)
                )

            Text("Hour Clock")
                .offset(x: -125)
                .foregroundColor(.white)
                .padding(.bottom, -10)

            TextField("", text: $newhours)
                .keyboardType(.numberPad)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.0)
                )

            Text("Minute Clock")
                .offset(x: -117)
                .foregroundColor(.white)
                .padding(.bottom, -10)

            TextField("", text: $newminutes)
                .keyboardType(.numberPad)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1.0)
                )

            Toggle("Notification", isOn: $isSelected)
                .padding()
                .foregroundColor(.white)

            Button {
                guard !newmed.isEmpty, let hours = Int(newhours), let minutes = Int(newminutes) else {
                    return
                }

                let newMed = DataType(
                    id: UUID().uuidString,
                    userId: datamanager.userId ?? "",
                    medicine: newmed,
                    hours: hours,
                    minutes: minutes,
                    isSelected: isSelected
                )

                onAddMed(newMed)
                datamanager.fetchData()  // Refresh data after adding a new medicine

                if isSelected {
                    dispatchNotification(for: newMed)
                }

                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .frame(width: 100, height: 40)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(.black)))
                    .foregroundColor(.white)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 20)
        .background(Color(red: 34.0/255.0, green: 40.0/255.0, blue: 49.0/255.0, opacity: 1.0))
        .ignoresSafeArea()
    }

    func dispatchNotification(for meds: DataType) {
        let identifier = UUID().uuidString
        let title = "Time for Medicine: \(meds.medicine)"
        let body = "Take your medicine now."

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        dateComponents.hour = meds.hours
        dateComponents.minute = meds.minutes

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
