//
//  AlertView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import SwiftUI
struct AlertView: View {
    @ObservedObject var viewmodel: AlertViewModel
    @State private var isExpanded = false
    @State private var hoverColor = Color.blue
    @State var hoveredItemIndex = 0
    let buttonColors = [
        "#87CEEB", "#89CFF0", "#B0E0E6", "#AFEEEE", "#E0FFFF",
        "#ADD8E6", "#BBDDFF", "#C3E6F9", "#D3E0F0", "#DDEBF5"
    ]
    
    var body: some View {
        HStack {
            AlertDropDown(viewmodel: viewmodel)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<viewmodel.alerts.count, id: \.self) { index in
                        Button {
                            viewmodel.selectAlert(index: index)
                        } label: {
                            Text("\(viewmodel.alerts[index].token) - \(String(format: "%.4f", viewmodel.alerts[index].marketScore ))%")
                                .lineLimit(1)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color(hex: buttonColors[index < viewmodel.alerts.count ? index: 9]))
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .stroke(.black, lineWidth: viewmodel.selectedAlert?.id == viewmodel.alerts[index].id ? 3 : 0)
                                )
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(3)
                }
            }
        }
    }
}
