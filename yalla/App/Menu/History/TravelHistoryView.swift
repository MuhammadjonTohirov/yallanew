//
//  TravelHistoryView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 31/10/25.
//

import SwiftUI
import YallaKit
import IldamSDK
import YallaUtils

struct TravelHistoryView: View {
    @StateObject private var viewModel = TravelHistoryViewModel()
    
    // MARK: - View State
    @State private var route: TravelHistoryRoute?
    @State private var showDetails: Bool = false

    var body: some View {
        PageableScrollView(title: "".localize, bottomThreshold: 200) {
            viewModel.loadNextPage()
        } content: {
            LazyVStack(alignment: .leading, spacing: 0) {
                TripCategoryView()
                HistorySectionsListView(
                    sections: viewModel.sections,
                    onItemTap: { orderId in
//                        navigateToOrderDetails(orderId)
                    }
                )
                
                FooterLoadingView(isLoading: viewModel.isLoading || viewModel.hasNextPage)
            }
            .padding(.horizontal, 20)
        }
        .opacity(viewModel.isLoading && viewModel.sections.isEmpty ? 0.6 : 1)
        .navigationDestination(isPresented: $showDetails) {
            route?.screen
                .onDisappear {
                    route = nil
                }
        }
//        .standardLoader(isLoading: viewModel.isLoading && viewModel.sections.isEmpty)
        
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("my.trips".localize)
    }
    
}

// MARK: - Loading Footer Component
struct FooterLoadingView: View {
    let isLoading: Bool
    
    var body: some View {
        if isLoading {
            HStack(spacing: 8) {
                ProgressView()
                    .frame(width: 20, height: 20)
                
                Text("loading".localize)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Section History Sections ListView
struct HistorySectionsListView: View {
    let sections: [TravelHistorySection]
    let onItemTap: (Int) -> Void
    
    var body: some View {
        ForEach(sections) { section in
            LazyVStack(alignment: .leading, spacing: 0) {
                HistorySectionTitle(title: section.title)
                
                ForEach(section.items) { item in
                    HistoryListItemView(item: item)
                        .padding(.bottom, 8)
                        .onTapGesture {
                            onItemTap(item.id)
                        }
                }
            }
        }
    }
}

// MARK: - Section Title Component
struct HistorySectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title.localize)
            .listRowSeparator(.hidden)
            .font(.system(size: 20, weight: .bold))
            .frame(height: 60)
    }
}

#Preview {
    TravelHistoryView()
}
