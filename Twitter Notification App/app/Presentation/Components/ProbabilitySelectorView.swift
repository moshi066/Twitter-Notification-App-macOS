//
//  SelectOperationsView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/19/23.
//

import SwiftUI

struct ProbabilitySelectorView: View {
    @ObservedObject var viewmodel : AlertViewModel
    @State var customInput: String = ""
    @State var validInput = false
    @State var selectedOption = ""
    @State var eventMonitor: Any? = nil
    
    var body: some View {
        VStack {
            HStack{
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(index == 0 ? .black : Color(hex: "#dedede"))
                        .frame(height: 8)
                }
            }
            .padding(.horizontal)
            HStack {
                Text("Step 1: Probability")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                Spacer()
                
                CustomRadioButtonsWithCustomPercentage(optionNames: .constant(["High", "Medium", "Low", "Don't Know"]), selectedOption: $selectedOption, customInput: $customInput)
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
                Spacer()
                Button {
                    enterButtonPressed()
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
        viewmodel.selectedAlert?.probability = selectedOption == "Custom" ? customInput + "%" : selectedOption
    }
}
