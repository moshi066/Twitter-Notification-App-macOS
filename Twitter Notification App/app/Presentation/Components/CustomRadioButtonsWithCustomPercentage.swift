//
//  CustomRadioButtonsWithCustomPercentage.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/21/23.
//

import SwiftUI

struct CustomRadioButtonsWithCustomPercentage: View {
    @Binding var optionNames: [String]
    @Binding var selectedOption: String
    @Binding var customInput: String
    @State var selectedOptionIndex = 0
    @FocusState private var customHasFocus: Bool
    @State private var disabled = true
    @State var eventMonitor: Any? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<optionNames.count, id: \.self) { index in
                Button {
                    selectedOptionIndex = index
                    customHasFocus = false
                    selectedOption = optionNames[index]
                } label: {
                    Text(optionNames[index])
                        .lineLimit(1)
                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(getButtonColor(title: optionNames[index], isSelected: selectedOptionIndex == index))
                        .clipShape(.capsule)
                        .overlay(
                            Capsule()
                                .stroke(Color(hex: "#666666"), lineWidth: selectedOptionIndex == index ? 3 : 0)
                        )
                }
                .buttonStyle(.borderless)
            }
            .padding(3)
            Text("|")
                .foregroundStyle(Color(hex: "#00000026"))
                .padding(.leading, 2)
                .padding(.trailing, 5)
            
            ZStack {
                TextField("Custom %", text: $customInput)
                    .opacity(customInput.isEmpty ? 1 : 0)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .focused($customHasFocus)
                    .textFieldStyle(.plain)
                    .disabled(disabled)
                    .onAppear {
                        DispatchQueue.main.async {
                            disabled = false
                        }
                    }
                    .onChange(of: customHasFocus) {
                        if customHasFocus {
                            selectedOptionIndex = optionNames.count
                            selectedOption = "Custom"
                        }
                    }
                Text("\(customInput)%")
                    .opacity(customInput.isEmpty ? 0 : 1)
                    .lineLimit(1)
                    .truncationMode(.head)
            }
            .padding()
            .frame(maxWidth: 110)
            .background(getButtonColor(title: "Custom", isSelected: customHasFocus))
            .foregroundStyle(.black)
            .clipShape(.capsule)
            .onTapGesture {
                customHasFocus = true
            }
            .overlay(
                Capsule()
                    .stroke(Color(hex: "#666666"), lineWidth: customHasFocus ? 2 : 0)
            )
            .onAppear {
                selectedOption = optionNames[selectedOptionIndex]
                self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                    if(event.keyCode == CGKeyCode(0x35)) {
                        if(customHasFocus) {
                            customHasFocus = false
                            selectedOptionIndex = optionNames.count - 1
                        }
                    }
                    if(self.customHasFocus) {
                        return event
                    }
                    if(event.keyCode == CGKeyCode(0x7B)) {
                        selectedOptionIndex = selectedOptionIndex > 0 ? selectedOptionIndex - 1: selectedOptionIndex
                        return nil
                    }
                    if(event.keyCode == CGKeyCode(0x7C)) {
                        selectedOptionIndex = selectedOptionIndex < optionNames.count ? selectedOptionIndex + 1: selectedOptionIndex
                        return nil
                    }
                    return event
                }
            }
            .onDisappear {
                NSEvent.removeMonitor(self.eventMonitor as Any)
            }
            .onChange(of: selectedOptionIndex) {
                if(selectedOptionIndex == optionNames.count) {
                    selectedOption = "Custom"
                    customHasFocus = true
                } else {
                    selectedOption = optionNames[selectedOptionIndex]
                    customHasFocus = false
                }
            }
        }
        .background(Color(hex: "#E8E8E8"))
        .clipShape(.capsule)
    }
    func getButtonColor(title: String, isSelected: Bool) -> Color {
        if (title == "High" || title == "Buy") {
            return isSelected ? Color(hex: "#90EE90") : Color(hex: "#D4F5D4")
        }
        if (title == "Medium") {
            return isSelected ? Color(hex: "#FFDAB9") : Color(hex: "#FFF5E0")
        }
        if (title == "Low") {
            return isSelected ? Color(hex: "#FFC0CB") : Color(hex: "#FFE6E6")
        }
        if (title == "Don't Know") {
            return isSelected ? Color(hex: "#ADD8E6") : Color(hex: "#E6E6FF")
        }
        return isSelected ? Color(hex: "#CCCCCC") : Color(hex: "#D5D5D5")
    }
}

