//
//  AlertDropDown.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/13/23.
//

import SwiftUI

struct AlertDropDown: View {
    @ObservedObject var viewmodel: AlertViewModel
    @State private var isExpanded = false
    @State private var hoverColor = Color.blue
    @State var hoveredItemIndex = 0
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 20) {
                Text("Crypto")
                    .foregroundStyle(Color(hex: "#22222259"))
                Text("|")
                    .foregroundStyle(Color(hex: "#00000026"))
                
                HStack(spacing: 5) {
                    Text(viewmodel.selectedAlert?.token ?? "")
                    Text("-")
                    Text("\(String(format: "%.4f", viewmodel.selectedAlert?.marketScore ?? 0.0))%")
                        .foregroundStyle(Color(hex: "#1DA1F2FF"))
                }
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.default, value: isExpanded)
            }
            .padding()
            .background(Color(hex: "#00000014"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isExpanded) {
            ScrollView {
                VStack {
                    ForEach(0..<viewmodel.alerts.count, id: \.self) { index in
                        Button {
                            viewmodel.selectAlert(index: index)
                            withAnimation {
                                isExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(viewmodel.selectedAlert?.id == viewmodel.alerts[index].id ? (hoveredItemIndex == index ? .white : .black) : .clear)
                                Spacer()
                                Text("\(viewmodel.alerts[index].token) - \(String(format: "%.4f", viewmodel.alerts[index].marketScore ))%")
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
                }
                .padding()
            }
        }
        .padding()
        .sheet(isPresented: .constant(viewmodel.isLoading)) {
            ProgressView()
                .padding()
        }
    }
}

