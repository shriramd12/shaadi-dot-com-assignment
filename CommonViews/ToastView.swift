import SwiftUI

struct ToastView: View {
    let message: String
    let background: Color

    init(message: String, background: Color = Color.black.opacity(0.8)) {
        self.message = message
        self.background = background
    }
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(background)
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.opacity)
            .animation(.easeInOut,value: message)
    }
}
