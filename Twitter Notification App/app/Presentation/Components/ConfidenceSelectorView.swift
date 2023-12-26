//
//  ConfidenceSelectorView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/22/23.
//

import SwiftUI

struct ConfidenceSelectorView: View {
    @ObservedObject var viewmodel: AlertViewModel
    @State var customInput: String = ""
    @State var validInput = false
    @State var selectedOption = ""
    @State var eventMonitor: Any? = nil
    @State var isCustomProbabilityPressed = false
    @State var isCustomNewsForcePressed = false
    
    var body: some View {
        VStack {
            HStack{
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(index == 2 ? .black : Color(hex: "#dedede"))
                        .frame(height: 8)
                }
            }
            .padding(.horizontal)
            HStack {
                Text("Step 3: Confidence")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                Spacer()
                CustomRadioButtonsWithCustomPercentage(optionNames: .constant(["High", "Medium", "Low"]), selectedOption: $selectedOption, customInput: $customInput)
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 0)
            
            HStack {
                Spacer()
                Text("Please input a valid percentage.")
                    .foregroundStyle(.red)
                    .padding(0)
                    .opacity(selectedOption == "Custom" && !validInput && customInput.count > 0 ? 1: 0)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 0)
            HStack {
                CustomDropDown(title: .constant("Probability"), optionNames: .constant(["High", "Medium", "Low", "Don't Know", "Custom"]), selectedOption: Binding<String>(
                    get: { viewmodel.selectedAlert?.probability ?? "" },
                    set: { newValue in
                        viewmodel.selectedAlert?.probability = newValue
                    }), isCustomPressed: $isCustomProbabilityPressed)
                CustomDropDown(title: .constant("News Force"), optionNames: .constant(["High", "Medium", "Low", "Don't Know", "Custom"]), selectedOption: Binding<String>(
                    get: { viewmodel.selectedAlert?.newsForce ?? "" },
                    set: { newValue in
                        viewmodel.selectedAlert?.newsForce = newValue
                    }), isCustomPressed: $isCustomNewsForcePressed)
                Spacer()
                Button {
                    viewmodel.selectedAlert?.confidence = selectedOption
                    
                } label: {
                    Text("Confirm ->")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .buttonStyle(.plain)
                .disabled(selectedOption == "Custom" && !validInput || selectedOption == "")
            }
            .padding([.horizontal, .bottom])
            .padding(.vertical, 0)
            
        }
        .background(.white)
        .onChange(of: isCustomProbabilityPressed) {
            manageKeyboardEvent(isCustom: isCustomProbabilityPressed)
        }
        .onChange(of: isCustomNewsForcePressed) {
            manageKeyboardEvent(isCustom: isCustomProbabilityPressed)
        }
        
        .onChange(of: customInput) {
            if let percentage = Float(customInput), (0...100).contains(percentage) {
                self.validInput = true
            } else {
                self.validInput = false
            }
        }
        .onAppear {
            self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if(event.keyCode == CGKeyCode(0x24)) {
                    enterButtonPressed()
                    return nil
                }
                return event
            }
        }
        .onDisappear {
            NSEvent.removeMonitor(self.eventMonitor as Any)
        }
    }
    func enterButtonPressed() {
        if (selectedOption == "Custom" && !validInput) {
            return
        }
        viewmodel.selectedAlert?.confidence = selectedOption == "Custom" ? customInput + "%" : selectedOption
    }
    func manageKeyboardEvent(isCustom: Bool) {
        if(isCustom == true) {
            NSEvent.removeMonitor(self.eventMonitor as Any)
        } else {
            self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if(event.keyCode == CGKeyCode(0x24)) {
                    enterButtonPressed()
                    return nil
                }
                return event
            }
        }
        
    }
    
}

