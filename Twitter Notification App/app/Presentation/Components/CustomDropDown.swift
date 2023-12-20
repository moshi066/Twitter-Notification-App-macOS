//
//  CustomDropDown.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/18/23.
//

import SwiftUI



struct CustomDropDown: View {
    @Binding var title: String
    @Binding var optionNames: [String]
    @Binding var selectedOption: String
    @State private var isExpanded = false
    @State private var hoverColor = Color.blue
    @State var hoveredItemIndex = 0
    @Binding var isCustomPressed: Bool
    @State var errorMessage = ""
    @State var userInput = ""
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 20) {
                Text(title)
                    .lineLimit(1)
                    .foregroundStyle(Color(hex: "#22222259"))
                Text("|")
                    .foregroundStyle(Color(hex: "#00000026"))
                
                Text(selectedOption)
                    .lineLimit(1)
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.default, value: isExpanded)
            }
            .padding()
            .background(Color(hex: "#00000014"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isCustomPressed) {
            InputPopup(userInput: $userInput, isShowingPopup: $isCustomPressed)
                .onDisappear {
                    isCustomPressed = false
                }
        }
        .sheet(isPresented: $isExpanded) {
            ScrollView {
                VStack {
                    ForEach(0..<optionNames.count, id: \.self) { index in
                        Button {
                            selectedOption = optionNames[index]
                            isExpanded = false
                            if(optionNames[index] == "Custom") {
                                isCustomPressed = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(selectedOption == optionNames[index] ? (hoveredItemIndex == index ? .white : .black) : .clear)
                                Spacer()
                                Text(optionNames[index])
                                    .foregroundStyle(hoveredItemIndex == index ? .white : .black)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(hoveredItemIndex == index ? hoverColor : .white)
                        }
                        .buttonStyle(.plain)
                        .clipShape(.capsule)
                        .onHover { hovering in
                            if hovering {
                                hoverColor = .blue
                                hoveredItemIndex = index
                            }
                        }
                    }
                    if !optionNames.contains(where: { $0 == selectedOption }) {
                        Button {
                            withAnimation {
                                isExpanded.toggle()
                            }
                            
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(hoveredItemIndex == 066 ? .white : .black)
                                Spacer()
                                Text(selectedOption)
                                    .foregroundStyle(hoveredItemIndex == 066 ? .white : .black)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(hoveredItemIndex == 066 ? hoverColor : .white)
                        }
                        .buttonStyle(.plain)
                        .clipShape(.capsule)
                        .onHover { hovering in
                            if hovering {
                                hoverColor = .blue
                                hoveredItemIndex = 066
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onChange(of: isCustomPressed) {
            if(userInput != "") {
                selectedOption = userInput + "%"
            }
        }
    }
}
