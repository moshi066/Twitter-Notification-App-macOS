//
//  CustomRadioButtons.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/16/23.
//

import SwiftUI

struct CustomRadioButtons: View {
    @Binding var optionNames: [String]
    @Binding var selectedOption: String
    @State var selectedOptionIndex = 0
    @State var eventMonitor: Any? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<optionNames.count, id: \.self) { index in
                Button {
                    selectedOptionIndex = index
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
            .onAppear {
                selectedOption = optionNames[selectedOptionIndex]
                self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                    if(event.keyCode == CGKeyCode(0x7B)) {
                        selectedOptionIndex = selectedOptionIndex > 0 ? selectedOptionIndex - 1: selectedOptionIndex
                        return nil
                    }
                    if(event.keyCode == CGKeyCode(0x7C)) {
                        selectedOptionIndex = selectedOptionIndex + 1 < optionNames.count ? selectedOptionIndex + 1: selectedOptionIndex
                        return nil
                    }
                    return event
                }
            }
            .onDisappear {
                NSEvent.removeMonitor(self.eventMonitor as Any)
            }
            .onChange(of: selectedOptionIndex) {
                selectedOption = optionNames[selectedOptionIndex]
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
        return isSelected ? Color(hex: "#DDDDDD") : Color(hex: "#F0F0F0")
    }
}
