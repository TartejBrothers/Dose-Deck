import SwiftUI

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
                            Text("Login")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 20)
                            Text("Enter Your Email")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
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
                                .foregroundColor(.white)
                                .offset(x: -90)
                                .padding(.top,20)
                            TextField("", text: $email)
                                .accessibilityLabel("Email")
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4), lineWidth: 1.0)
                                )
                                .padding(.horizontal, 20)
                                
                        
                        }
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
