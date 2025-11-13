//
//  TripRatingView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 10/11/25.
//

import SwiftUI
import YallaUtils
import Core

// MARK: - Main View
struct RideFeedbackView: View {
    @StateObject private var viewModel = RideFeedbackViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            PaymentSection(amount: "44500")
            
            RatingSection(rating: $viewModel.rating)
            
            TipSection(
                tipOptions: viewModel.tipOptions,
                selectedTip: $viewModel.selectedTip
            )
            
            FeedbackSection(
                feedbackOptions: viewModel.feedbackOptions,
                selectedFeedback: $viewModel.selectedFeedback
            )
            
 
            SubmitButton(backgroundColor: .iPrimary) {
                Text("done".localize)
            }
            action: {
                viewModel.submitFeedback()
            }
            .padding(.horizontal)
        }
     }
}

// MARK: - Payment Section
struct PaymentSection: View {
    let amount: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text("payment.by.card".localize)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text("\(amount.asDouble.float.asMoneySum)")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.iLabel)
        }
        .padding(.top, 40)
        .padding(.bottom, 30)
    }
}

// MARK: - Rating Section
struct RatingSection: View {
    @Binding var rating: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("trip.feedback.question".localize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.iLabel)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { index in
                    StarButton(index: index, rating: $rating)
                }
            }
        }
        .padding(.bottom, 40)
    }
}

// MARK: - Star Button
struct StarButton: View {
    let index: Int
    @Binding var rating: Int
    
    private var isSelected: Bool {
        index <= rating
    }
    
    var body: some View {
        Button(action: { rating = index }) {
            Image(isSelected ? "icon_active_star" : "icon_noactive_star")
                .resizable()
                .frame(width: 66, height: 66)
        }
    }
}

// MARK: - Tip Section
struct TipSection: View {
    let tipOptions: [Int]
    @Binding var selectedTip: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("tip.driver".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.iLabel)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(tipOptions, id: \.self) { amount in
                        TipButton(
                            amount: Float(amount),
                            isSelected: selectedTip == amount
                        ) {
                            selectedTip = amount
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 32)
    }
}

// MARK: - Tip Button
struct TipButton: View {
    let amount: Float
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(amount.asMoneySum)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? .white : .iLabel)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(isSelected ? Color.iPrimary : Color.iBackgroundSecondary)
                .cornerRadius(25)
        }
    }
}

// MARK: - Feedback Section
struct FeedbackSection: View {
    let feedbackOptions: [FeedbackOption]
    @Binding var selectedFeedback: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("trip.feedback.like".localize)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.iLabel)
                .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(feedbackOptions) { option in
                        FeedbackButton(
                            option: option,
                            isSelected: selectedFeedback.contains(option.id)
                        ) {
                            toggleFeedback(option.id)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 40)
    }
    
    private func toggleFeedback(_ id: String) {
        if selectedFeedback.contains(id) {
            selectedFeedback.remove(id)
        } else {
            selectedFeedback.insert(id)
        }
    }
}

// MARK: - Feedback Button
struct FeedbackButton: View {
    let option: FeedbackOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(option.icon)
                    .font(.system(size: 32))
                
                Text(option.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .iLabel)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isSelected ? Color.iPrimary : Color.iBackgroundSecondary)
            .cornerRadius(16)
        }
    }
}



// MARK: - Preview
#Preview {
    RideFeedbackView()
}
