//
//  NewsContentView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/5/23.
//

import SwiftUI

struct NewsContentView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                VStack (alignment: .leading, spacing: 5) {
                    Profile(newsViewModel: newsViewModel)
                        .padding(.bottom)
                    Text(newsViewModel.selectedNews?.title ?? "")
                        .font(.title2)
                        .bold()
                    Text(newsViewModel.selectedNews?.body ?? "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: "#222222A6"))
                        .lineLimit(10)
                    
                    Spacer()
                    Divider()
                    
                    Text("\(newsViewModel.selectedNews?.time.getTimeDifferenceString() ?? "")")
                        .foregroundStyle(Color(hex: "#9f9f9f"))
                        .padding()
                }
                .padding()
                Spacer()
                ZStack (alignment: .topTrailing) {
                    AsyncImage(url: newsViewModel.selectedNews?.image) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "photo")
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Button(action: {
                        NSWorkspace.shared.open((newsViewModel.selectedNews?.url ?? newsViewModel.selectedNews?.link)!)
                    }) {
                        Label("Open in browser", systemImage: "globe")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                    .buttonStyle(.plain)
                }
                .frame(height: geometry.size.height)
            }
        }
        .background(Color(hex: "#0000000A"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(.white)
        
    }
    
}
