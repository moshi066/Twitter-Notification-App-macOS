//
//  NewsView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/4/23.
//

import SwiftUI
import AlertToast

struct NewsView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var viewmodel = NewsViewModel()
    @ObservedObject var alertViewModel = AlertViewModel()
    @State var isShowingToast = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var rotationAngle = 0.0
    @State var currentDate = Date()
    @State var selectedTweetIndex = -1
    @State var tabNames = ["Points", "Recent", "Unread"]
    @State private var selectedTab = -1
    
    var body: some View {
        GeometryReader {geometry in
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Today: \(currentDate.toString(withFormat: "dd MMM yyyy"))")
                        .font(.title)
                    
                    Button {
                        viewmodel.loadNews(count: nil, token: alertViewModel.selectedAlert?.token)
                    } label: {
                        HStack {
                            Text("Last updated: \(viewmodel.getLastRefreshedString(currentTime: currentDate) )")
                                .foregroundStyle(.gray)
                                .font(.title3)
                                .onReceive(timer) {_ in
                                    currentDate = Date()
                                }
                            if(viewmodel.isLoading) {
                                ProgressView()
                                    .controlSize(.small)
                                    .padding(.horizontal)
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 12)
                            }
                        }
                        
                    }
                    .buttonStyle(.plain)
                    
                    
                    ZStack(alignment: .topTrailing) {
                        CustomTabbar(selectedTab: $selectedTab, tabNames: $tabNames)
                            .onAppear {
                                selectedTab = 0
                            }
                        HStack {
                            Text("\(viewmodel.newsItems.filter { !$0.read }.count)")
                                .bold()
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(viewmodel.newsItems.filter { !$0.read }.count == 0 ? .green: .red)
                                .background(.ultraThinMaterial)
                                .clipShape(.circle)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            Spacer()
                                .frame(width: 5)
                        }
                        .padding(.top, -10)
                        
                        
                    }
                    .padding(.vertical)
                    .onChange(of: selectedTab) {
                        if(selectedTab == 0) {
                            viewmodel.sortNewsByPoint()
                        }
                        else if(selectedTab == 1) {
                            viewmodel.sortNewsByTime()
                        } else if(selectedTab == 2) {
                            viewmodel.filterNewsByUnread()
                        }
                    }
                    
                    VStack{
                        if(viewmodel.selectedNews == nil) {
                            Text("No Tweets available")
                                .foregroundStyle(Color(hex: "#969696"))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background(Color(hex: "#f5f5f5"))
                                .padding()
                        } else {
                            ScrollView {
                                ForEach(0..<viewmodel.news.count, id: \.self) { index in
                                    Button {
                                        viewmodel.selectNews(index: index)
                                    } label: {
                                        NewsCardView(newsViewModel: viewmodel, news: .constant(viewmodel.news[index]))
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                                            if(event.keyCode == CGKeyCode(0x7E)) {
                                                viewmodel.upArrowKeyPressed()
                                                return nil
                                            }
                                            if(event.keyCode == CGKeyCode(0x7D)) {
                                                viewmodel.downArrowKeyPressed()
                                                return nil
                                            }
                                            return event
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width * 0.30)
                
                Divider()
                    .padding(0)
                
                if(viewmodel.news.count != 0) {
                    VStack(alignment: .leading) {
                        AlertView(viewmodel: alertViewModel)
                        if(viewmodel.selectedNews != nil) {
                            SelectedNewsView(newsViewModel: viewmodel)
                        } else {
                            
                            HStack {
                                Spacer()
                                Text("Please select a news")
                                    .foregroundStyle(Color(hex: "#969696"))
                                    .fontWeight(.medium)
                                    .font(.system(size: 25))
                                Spacer()
                            }
                            Spacer()
                        }
                        Divider()
                            .padding(0)
                        FeebackView(viewmodel: alertViewModel)
                    }
                } else {
                    VStack(spacing: -50) {
                        Image("wating_bro")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 400)
                        Text("Please wait for new tweets to be added")
                            .foregroundStyle(Color(hex: "#969696"))
                            .fontWeight(.medium)
                            .font(.system(size: 17))
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
            }
            .background(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: alertViewModel.selectedAlert) {
            if(alertViewModel.selectedAlert != nil) {
                viewmodel.loadNews(count: nil, token: alertViewModel.selectedAlert?.token)
            }
        }
        .onChange(of: alertViewModel.alertsReloaded) {
            if(alertViewModel.alertsReloaded) {
                viewmodel.loadNews(count: nil, token: alertViewModel.selectedAlert?.token)
                alertViewModel.alertsReloaded = false
            }
        }
        .onChange(of: alertViewModel.selectedAlert?.probability) {
            if(alertViewModel.selectedAlert?.probability == "") {
                return
            }
            viewmodel.sendFeedback(newsId: viewmodel.selectedNews?._id ?? "", feedbackType: "probability", feedbackValue: alertViewModel.selectedAlert?.probability ?? "", token: alertViewModel.selectedAlert?.token ?? "")
        }
        .onChange(of: alertViewModel.selectedAlert?.newsForce) {
            if(alertViewModel.selectedAlert?.newsForce == "") {
                return
            }
            viewmodel.sendFeedback(newsId: viewmodel.selectedNews?._id ?? "", feedbackType: "news_force", feedbackValue: alertViewModel.selectedAlert?.newsForce ?? "", token: alertViewModel.selectedAlert?.token ?? "")
        }
        .toast(isPresenting: $viewmodel.isNewNewsAdded, duration: 1) {
            AlertToast(type: .systemImage("info.circle", Color.black), title: "Alert", subTitle: "New News has been addded")
        }
        .onChange(of: alertViewModel.selectedAlert?.confidence) {
            if(alertViewModel.selectedAlert?.confidence == "") {
                return
            }
            viewmodel.sendFeedback(newsId: viewmodel.selectedNews?._id ?? "", feedbackType: "confidence", feedbackValue: alertViewModel.selectedAlert?.confidence ?? "", token: alertViewModel.selectedAlert?.token ?? "")
        }
        .onChange(of: appDelegate.isNewNotificationArrived) {
            if(appDelegate.isNewNotificationArrived) {
                alertViewModel.loadAlerts(count: 10)
                viewmodel.loadNews(count: 10, token: alertViewModel.selectedAlert?.token)
                appDelegate.isNewNotificationArrived = false
            }
        }
        .onChange(of: alertViewModel.selectedAlert?.buyOrSell) {
            if(alertViewModel.selectedAlert?.buyOrSell == "") {
                return
            }
            viewmodel.sendFeedback(newsId: viewmodel.selectedNews?._id ?? "", feedbackType: "buy_or_sell", feedbackValue: alertViewModel.selectedAlert?.buyOrSell ?? "", token: alertViewModel.selectedAlert?.token ?? "")
        }
    }
}

