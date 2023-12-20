//
//  InputPop.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/5/23.
//

import SwiftUI

struct InputPopup: View {
    @Binding var userInput: String
    @Binding var isShowingPopup: Bool
    @State var validInput = false
    @FocusState var focus: Bool
    @State var eventMonitor: Any?
    
    var body: some View {
        VStack {
            TextField("Enter percentage", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focus)
                .padding()
                .onAppear {
                    focus = true
                    self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                        if(event.keyCode == CGKeyCode(0x24)) {
                            delayedAccept()
                            return nil
                        }
                        return event
                    }
                }
                .onDisappear {
                    NSEvent.removeMonitor(eventMonitor as Any)
                }
            
            Text("Please enter a valid percentage")
                .foregroundColor(.red)
                .opacity(!validInput && !userInput.isEmpty ? 1 : 0)
            
            Button("Save") {
                isShowingPopup = false
            }
            .disabled(!validInput)
            .padding()
        }
        .onAppear {
            if let percentage = Float(userInput), (0...100).contains(percentage) {
                self.validInput = true
            } else {
                self.validInput = false
            }
        }
        .padding()
        .frame(minWidth: 300)
        .onChange(of: userInput) {
            if let percentage = Float(userInput), (0...100).contains(percentage) {
                self.validInput = true
            } else {
                self.validInput = false
            }
        }
    }
    func delayedAccept() {
        if validInput {
            isShowingPopup = false
        }
    }
}
