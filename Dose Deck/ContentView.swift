import SwiftUI
import Firebase
struct ContentView: View {
    @State private var email=""
    @State private var password=""
    var body: some View {
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
                            .padding(.top,150.0)
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
                            TextField("", text: $email)
                                .accessibilityLabel("Email")
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4), lineWidth: 1.0)
                                )
                                .padding(.horizontal, 20)
                            Text("Enter Your Password")
                                .fontWeight(.bold)
                                .foregroundColor(Color(red:1.0, green:1.0, blue: 1.0, opacity: 0.7))
                                .offset(x: -85)
                                .padding(.top,20)
                            TextField("", text: $password)
                                .accessibilityLabel("Password")
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4), lineWidth: 1.0)
                                )
                                .padding([.leading, .bottom, .trailing], 20)
                            Button{
                                register()
                            } label: {
                                Text("Sign Up")
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height:40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20,style: .continuous ).fill(Color(.black)))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)

                            }
                            Button{
                                login()
                            } label: {
                                Text("Have an Account? Login here")
                                    .foregroundColor(.white)
                            }
                            
                        
                        }
                    }
                }
            }
        }.ignoresSafeArea()
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

