//
//  TravelHistoryViewModel.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 01/04/25.
//

import Foundation
import SwiftUI
import IldamSDK
import Core
import Combine


class TravelHistoryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var sections: [TravelHistorySection] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var hasNextPage: Bool = false
    
    // MARK: - Private Properties
    private var currentPage: Int = 1
    private let pageLimit: Int = 15
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        loadInitialHistory()
    }
    
    // MARK: - Public Methods
    func refreshHistory() {
        currentPage = 1
        sections = []
        loadHistory()
    }
    
    func loadNextPage() {
        guard !isLoading && hasNextPage else { return }
        
        currentPage += 1
        loadHistory()
    }
    
    // MARK: - Private Methods
    private func loadInitialHistory() {
        // Load the first page when the view model is initialized
        loadHistory()
    }
    
    private func loadHistory() {
        guard !isLoading else { return }
        
        setLoading(true)
        
        Task {
            Logging.l(tag: "TravelHistory", "page: \(currentPage) loadHistory")
            let history = await MainNetworkService.shared.loadHistory(page: currentPage, limit: pageLimit)
            
            await MainActor.run {
                self.processHistoryData(history?.list ?? [])
                self.hasNextPage = (history?.list.count ?? 0) >= pageLimit
                self.setLoading(false)
            }
        }
    }
    
    private func processHistoryData(_ items: [OrderHistoryItem]) {
        // Group the items by date (section)
        var updatedSections = self.sections
        
        // If we're loading the first page, clear existing sections
        if currentPage == 1 {
            updatedSections = []
        }
        
        // Add incoming items to appropriate sections
        for item in items {
            let date = item.dateString
            
            if let index = updatedSections.firstIndex(where: { $0.title == date }) {
                // Update existing section
                updatedSections[index].items.append(item)
            } else {
                // Create new section
                updatedSections.append(TravelHistorySection(title: date, items: [item]))
            }
        }
        
        // Sort sections by date (newest first)
        // This would require converting string dates to actual Date objects for proper sorting
        // For now, we'll assume the API returns items in the correct order
        
        self.sections = updatedSections
    }
    
    private func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
        }
    }
}
