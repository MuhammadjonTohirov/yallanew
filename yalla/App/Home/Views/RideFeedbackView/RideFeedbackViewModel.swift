//
//  RideFeedbackViewModel.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 10/11/25.
//

import SwiftUI
import Combine

class RideFeedbackViewModel: ObservableObject {
    @Published var rating: Int = 4
    @Published var selectedTip: Int = 5000
    @Published var selectedFeedback: Set<String> = ["driving"]
    
    let tipOptions = [2000, 5000, 7000]
    
    let feedbackOptions = [
        FeedbackOption(id: "driving", icon: "🚗", title: "Аккуратное\nвождение"),
        FeedbackOption(id: "cleanliness", icon: "🧹", title: "Чистота в\nсалоне"),
        FeedbackOption(id: "communication", icon: "💬", title: "Приятное\nобщение"),
        FeedbackOption(id: "music", icon: "🎵", title: "Хорошая\nмузыка")
    ]
    
    func submitFeedback() {
        print("Rating: \(rating)")
        print("Tip: \(selectedTip)")
        print("Feedback: \(selectedFeedback)")
    }
}

struct FeedbackOption: Identifiable {
    let id: String
    let icon: String
    let title: String
}
