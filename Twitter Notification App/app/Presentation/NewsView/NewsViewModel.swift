//
//  NewsViewModel.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    
    @Published var isLoading = false
    
    var selectedNews: NewsEntity? {
        get {
            guard !news.isEmpty, let index = selectedNewsIndex else { return nil }
            return news[index]
        }
        set {
            guard let newValue = newValue, !news.isEmpty else { return }
            let foundIndex = newsItems.firstIndex(where: { $0.id == newValue.id })
            newsItems[foundIndex ?? 0] = newValue
        }
    }
    
    @Published var lastRefreshedAt = Date()
    private var previousToken = "";
    
    var news: [NewsEntity] {
        if (sortOrFilterMode == .date) {
            return newsItems.sorted{ $0.time > $1.time }
        }
        if (sortOrFilterMode == .point) {
            return newsItems.sorted{ $0.point > $1.point }
        }
        return newsItems.filter{$0.read == false }
    }
    
    @Published var selectedNewsIndex: Int?
    
    @Published var newsItems: [NewsEntity] = []
    
    private var newsUseCase: NewsUseCase
    
    private var feedbackUseCase: FeedbackUseCase
    
    private var sortOrFilterMode: NewsSortOrFilterType = .point
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.newsUseCase = NewsUseCase(newsRepository: NewsRepositoryImpl(baseUrl: URL(string: "http://cryptobot-user-feedback-api-prod.eba-usyp3675.ap-northeast-1.elasticbeanstalk.com/")!))
        
        self.feedbackUseCase = FeedbackUseCase(feedbackRepository: FeedbackRepositoryImpl(baseUrl: URL(string: "http://cryptobot-user-feedback-api-prod.eba-usyp3675.ap-northeast-1.elasticbeanstalk.com/")!))
    }
    
    public func getLastRefreshedString(currentTime: Date) -> String {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: lastRefreshedAt, to: currentTime)
        
        if let days = components.day, days != 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if let hours = components.hour, hours != 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if let minutes = components.minute, minutes != 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    
    func loadNews(count: Int?, token: String?) {
        self.isLoading = true
        
        self.newsUseCase.execute(count, token)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                    self.lastRefreshedAt = Date()
                    self.isLoading = false
                },
                receiveValue: { [unowned self] newItems in
                    if(token == previousToken) {
                        for newItem in newItems {
                            if !self.newsItems.contains(where: { $0.id == newItem.id }) {
                                self.newsItems.append(newItem)
                            }
                        }
                    }
                    else {
                        var tempItems: [NewsEntity] = []
                        for var newItem in newItems {
                            if let index = newsItems.firstIndex(where: { $0.id == newItem.id }) {
                                newItem.read = newsItems[index].read
                            }
                            tempItems.append(newItem)
                        }
                        self.newsItems = tempItems
                    }
                    if(self.news.count != 0) {
                        selectNews(index: 0)
                    }
                    if let newToken = token {
                        previousToken = newToken
                    }
                }
            )
            .store(in: &self.subscriptions)
    }
    public func sortNewsByTime() {
        if let selectedNews = selectedNews, let index = newsItems.firstIndex(where: { $0.id == selectedNews.id }) {
            newsItems[index].read = true
        }
        sortOrFilterMode = .date
        
        if(news.count > 0) {
            selectNews(index: 0)
        }
        
    }
    public func sortNewsByPoint() {
        if let selectedNews = selectedNews, let index = newsItems.firstIndex(where: { $0.id == selectedNews.id }) {
            newsItems[index].read = true
        }
        sortOrFilterMode = .point
        if(news.count > 0) {
            selectNews(index: 0)
        }
    }
    public func filterNewsByUnread() {
        sortOrFilterMode = .unread
        if(news.count > 0) {
            selectNews(index: 0)
        }
    }
    public func selectNews(index: Int) {
        var newIndex = index
        if let previousIndex = selectedNewsIndex {
            if(previousIndex == newIndex) {
                return
            }
            
            if let foundIndex = newsItems.firstIndex(where: { $0.id == news[previousIndex].id }) {
                newsItems[foundIndex].read = true
            }
            if(sortOrFilterMode == .unread && previousIndex < newIndex) {
                newIndex = newIndex - 1
            }
        }
        selectedNewsIndex = newIndex >= 0 ? newIndex : nil
        if selectedNewsIndex == nil {
            selectedNews = nil
        } else {
            selectedNews = news[selectedNewsIndex ?? 0]
        }
    }
    
    public func upArrowKeyPressed() {
        if let index = selectedNewsIndex {
            if(index > 0) {
                selectNews(index: index - 1)
            }
        }
    }
    
    public func downArrowKeyPressed() {
        if let index = selectedNewsIndex {
            if(index + 1 < news.count) {
                selectNews(index: index + 1)
            }
        }
    }
    
    public func sendFeedback(newsId: String, feedbackType: String, feedbackValue: String, token: String) {
        
        self.feedbackUseCase.execute(newsId, feedbackType, feedbackValue, token)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [unowned self] status in
                    
                }
            )
            .store(in: &self.subscriptions)
    }
}


enum NewsSortOrFilterType {
    case point
    case date
    case unread
}
