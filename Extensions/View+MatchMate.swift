//
//  View+MatchMate.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 03/09/24.
//

import SwiftUI

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 5.0, background: Color) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                ToastView(message: message, background: background)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                    .zIndex(1)  // Ensure the toast appears on top
                    .padding(.bottom, 50)  // Adjust the position
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
