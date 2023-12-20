//
//  NewsCardView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/4/23.
//

import SwiftUI

struct NewsCardView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    @Binding var news: NewsEntity
    
    var body: some View {
        HStack {
            if(news.url == nil) {
                Image(news.id == newsViewModel.selectedNews?.id ? "twitter_logo_white" : "twitter_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 23)
            } else {
                Image(systemName: "globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 23)
                    .foregroundStyle(news.id == newsViewModel.selectedNews?.id ? .white : .black)
            }
            Text(news.body)
                .lineLimit(1)
                .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                .foregroundStyle(news.id == newsViewModel.selectedNews?.id ? .white : news.read ? Color(hex: "#a1a1a1") : .black)
            Spacer()
            
            Text("\(news.point) Pts")
                .lineLimit(1)
                .foregroundStyle(news.id == newsViewModel.selectedNews?.id ? .white : .black)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color(hex: news.id == newsViewModel.selectedNews?.id ? "#FFFFFF40" : "#0000001A"))
                .clipShape(.capsule)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: news.id == newsViewModel.selectedNews?.id ? "#222222FF" : "#0000000A"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
