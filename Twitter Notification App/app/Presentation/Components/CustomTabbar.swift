//
//  CustomTabbar.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/16/23.
//

import SwiftUI

struct CustomTabbar: View {
    @Binding var selectedTab: Int
    @Binding var tabNames: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabNames.count, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    Text(tabNames[index])
                        .lineLimit(1)
                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                        .font(.headline)
                        .foregroundColor(selectedTab == index ? .white : .black)
                        .padding()
                    
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(selectedTab == index ? Color.black : Color.clear)
                        .clipShape(.capsule)
                }
                .buttonStyle(.borderless)
            }
        }
        .background(Color.init(red: 0, green: 0, blue: 0, opacity: 0.1))
        .clipShape(.capsule)
    }
}

#Preview {
    CustomTabbar(selectedTab: .constant(1), tabNames: .constant(["Points", "Recent", "Unread"]))
}
