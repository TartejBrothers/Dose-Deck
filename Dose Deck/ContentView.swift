import SwiftUI
import Firebase
import UserNotifications

struct ContentView: View {
    // Setting Variables and assigning value to datamanager.
    @State private var email = ""
    @State private var password = ""
    @Binding var userIsLogged: Bool // Checking if userisLoggedIn
    @StateObject private var datamanager = DataManager()
    
    let userIdKey = "UserId" // Assigned it to a temporary variable
    
    init(userIsLogged: Binding<Bool>) {
        _userIsLogged = userIsLogged // Assigning Value to the Variable
    }

    var body: some View {
        if userIsLogged {
            ListView(userIsLogged: $userIsLogged, userId: userIdKey)
                .environmentObject(datamanager)
            // If logged in, taking the user to the Medicine Page
            // Else giving the user the the option to create an account or login
        } else {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    GeometryReader { geometry in
                        ZStack(alignment: .top){
                            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                .foregroundColor(.white)
                            Text("Dose Deck")
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 41.0/255.0, green: 51.0/255.0, blue: 120.0/255.0, opacity: 1.0))
                                .font(.largeTitle)
                                .padding(.top, 80.0)
                            Text("Create an Account or Login to Save Medical Records")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.top, 150.0)
                        }
                    }
                    .frame(height: 0.3 * UIScreen.main.bounds.height)

                    GeometryReader { geometry in
                        ZStack(alignment: .top){
                            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                .foregroundColor(Color(red:34.0/255.0, green:40.0/255.0, blue: 49.0/255.0, opacity: 1.0))
                            VStack(alignment: .center) {
                                Text("Welcome")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical, 20)
                                Text("Enter Your Email")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red:1.0, green:1.0, blue: 1.0, opacity: 0.7))
                                    .offset(x: -100)
                                TextField("Email", text: $email)
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                    .foregroundColor(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4), lineWidth: 1.0)
                                    )
                                    .padding(.horizontal, 20)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                Text("Enter Your Password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red:1.0, green:1.0, blue: 1.0, opacity: 0.7))
                                    .offset(x: -85)
                                    .padding(.top, 20)
                                SecureField("Password", text: $password)
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                    .foregroundColor(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4), lineWidth: 1.0)
                                    )
                                    .padding([.leading, .bottom, .trailing], 20)

                                Button(action: register) {
                                    Text("Sign Up")
                                        .frame(width: 100, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(.black))
                                        )
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                }
                                .alert(isPresented: $datamanager.showAlert) {
                                    Alert(title: Text(datamanager.alertTitle), message: Text(datamanager.alertMessage), dismissButton: .default(Text("OK")))
                                }

                                Button(action: login) {
                                    Text("Have an Account? Login here")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    requestNotificationPermission()
                    loadUserIdFromUserDefaults()
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            userIsLogged.toggle()
                        }
                        // On appear, asking for notification permission for the first time
                        // If user is present, loading the list view
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    // Asking for permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    // Firebase Login function
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                datamanager.showAlert(title: "Error", message: "Invalid email or password.")
            } else {
                if let userId = Auth.auth().currentUser?.uid {
                    saveUserIdToUserDefaults(userId)
                    datamanager.setUserId(userId)
                }
                userIsLogged = true
            }
        }
    }
    // Firebase signup function, and once the account is created, it will take them to list view
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                datamanager.showAlert(title: "Error", message: "Unable to create an account. Please try again.")
            } else {
                if let userId = Auth.auth().currentUser?.uid {
                    saveUserIdToUserDefaults(userId)
                    datamanager.setUserId(userId)
                }
                userIsLogged = true
            }
        }
    }
    // Saving the user details, only the userID
    func saveUserIdToUserDefaults(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }
    // Calling for the userId
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    // Loading the userID
    func loadUserIdFromUserDefaults() {
        if let userId = getUserId() {
            datamanager.setUserId(userId)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userIsLogged: .constant(false))
    }
}
