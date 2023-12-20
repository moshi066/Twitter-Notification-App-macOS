//
//  SelectedNewsView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/5/23.
//

import SwiftUI


struct SelectedNewsView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    
    var body: some View {
        VStack (alignment: .leading){
            NewsContentView(newsViewModel: newsViewModel)
                .padding(.horizontal)
        }
        .padding(0)
    }
}
