//
//  ResultView.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/22/23.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewmodel: AlertViewModel
    @State var customInput: String = ""
    @State var validInput = false
    @State var isCustomProbabilityPressed = false
    @State var isCustomNewsForcePressed = false
    @State var isCustomConfidencePressed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .bottom) {
                Text("Result")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                
                HStack {
                    Text("Changes Saved")
                        .foregroundStyle(Color(hex: "#b2b2b2"))
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
                .padding(.leading)
                .padding(.bottom, 3)
            }
            .padding()
            
            Spacer()
                .frame(height: 58)
            
            HStack {
                CustomDropDown(title: .constant("Probability"), optionNames: .constant(["High", "Medium", "Low", "Don't Know", "Custom"]), selectedOption: Binding<String>(
                    get: { viewmodel.selectedAlert?.probability ?? "" },
                    set: { newValue in
                        viewmodel.selectedAlert?.probability = newValue
                    }), isCustomPressed: $isCustomProbabilityPressed)
                
                CustomDropDown(title: .constant("News Force"), optionNames: .constant(["High", "Medium", "Low", "Don't Know", "Custom"]), selectedOption: Binding<String>(
                    get: { viewmodel.selectedAlert?.newsForce ?? "" },
                    set: { newValue in
                        viewmodel.selectedAlert?.newsForce = newValue
                    }), isCustomPressed: $isCustomNewsForcePressed)
                
                CustomDropDown(title: .constant("Confidence"), optionNames: .constant(["High", "Medium", "Low", "Custom"]), selectedOption: Binding<String>(
                    get: { viewmodel.selectedAlert?.confidence ?? "" },
                    set: { newValue in
                        viewmodel.selectedAlert?.confidence = newValue
                    }), isCustomPressed: $isCustomConfidencePressed)
                
                CustomDropDown(title: .constant("Decision"), optionNames: .constant(["Buy", "Sell", "Don't Know"]), selectedOption: Binding<String>(
                    get: { viewmodel.selectedAlert?.buyOrSell ?? "" },
                    set: { newValue in
                        viewmodel.selectedAlert?.buyOrSell = newValue
                    }), isCustomPressed: .constant(false))
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
        }
    }
}


