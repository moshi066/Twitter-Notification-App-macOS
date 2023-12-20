//
//  AlertViewModel.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/3/23.
//

import Foundation
import Combine

class AlertViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    
    @Published var isLoading = false
    
    @Published var authSession: AuthSessionEntity?
    
    @Published var alerts: [AlertEntity] = []
    
    @Published var selectedAlertIndex: Int?
    
    private var cancellables = Set<AnyCancellable>()
    
    var selectedAlert: AlertEntity? {
        get {
            guard !alerts.isEmpty, let index = selectedAlertIndex else { return nil }
            return alerts[index]
        }
        set {
            guard let newValue = newValue, !alerts.isEmpty else { return }
            let foundIndex = alerts.firstIndex(where: { $0.id == newValue.id })
            alerts[foundIndex ?? 0] = newValue
        }
    }
    
    private var alertUseCase: AlertUseCase
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.alertUseCase = AlertUseCase(alertRepository: AlertRepositoryImpl(baseUrl: URL(string: "http://cryptobot-user-feedback-api-prod.eba-usyp3675.ap-northeast-1.elasticbeanstalk.com/")!))
        self.authSession = AuthSessionEntity(accessToken: "0MdQ7jAoAfs0JV0MMbkBK8O2YsyTILM7K4I6CwXzVlo")
        loadAlerts(count: 10)
        
        let timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.loadAlerts(count: 10)
            }
        cancellables.insert(timer)
    }
    
    func loadAlerts(count: Int?) {
        self.isLoading = true
        
        self.alertUseCase.execute(count)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                },
                receiveValue: { [unowned self]  newItems in
                    for newItem in newItems {
                        if !self.alerts.contains(where: { $0.id == newItem.id }) {
                            if let index = self.alerts.firstIndex(where: { $0.token == newItem.token }) {
                                self.alerts[index] = newItem
                            } else {
                                self.alerts.append(newItem)
                            }
                        }
                    }
                    
                    self.alerts = alerts.sorted(by: { $0.marketScore > $1.marketScore })
                    selectedAlertIndex = 0
                }
            )
            .store(in: &self.subscriptions)
        
    }
    
    public func selectAlert(index: Int) {
        selectedAlertIndex = index
    }
}
