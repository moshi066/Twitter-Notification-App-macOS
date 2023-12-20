//
//  FeebackView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/14/23.
//

import SwiftUI

struct FeebackView: View {
    @ObservedObject var viewmodel: AlertViewModel
    
    var body: some View {
        if(viewmodel.selectedAlert?.probability == "") {
            ProbabilitySelectorView(viewmodel: viewmodel)
        } else if(viewmodel.selectedAlert?.newsForce == "") {
            NewsForceSelectorView(viewmodel: viewmodel)
        } else if(viewmodel.selectedAlert?.confidence == "") {
            ConfidenceSelectorView(viewmodel: viewmodel)
        } else if(viewmodel.selectedAlert?.buyOrSell == "") {
            BuyOrSellSelectorView(viewmodel: viewmodel)
        } else {
            ResultView(viewmodel: viewmodel)
        }
    }
}
