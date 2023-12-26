//
//  ProfileView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/5/23.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var newsViewModel: NewsViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: newsViewModel.selectedNews?.icon) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 45, maxHeight: 45)
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 45, height: 45)
                @unknown default:
                    EmptyView()
                        .frame(width: 45, height: 45)
                }
            }
            .frame(width: 45, height: 45)
            .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(newsViewModel.selectedNews?.name ?? "")
                        .font(.title2)
                        .lineLimit(1)
                        .bold()
                        .padding(.trailing, 0)
                }
                Text(newsViewModel.selectedNews?.username ?? "")
                    .lineLimit(1)
                    .foregroundStyle(Color(hex: "#00000033"))
            }
        }
    }
}
