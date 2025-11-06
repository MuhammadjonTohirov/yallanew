//
//  CategoryItem.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 31/10/25.
//

import SwiftUI
import Core
import YallaUtils

enum CategoryKey: Equatable {
    case all
    case taxi
    case cargo
    case intercity
}

struct Category: Identifiable {
    let id = UUID()
    let icon: String
    let title: String 
    let key: CategoryKey
}

// MARK: - Main View
struct TripCategoryView: View {
    @Binding var selected: CategoryKey
    // All, Taxi, Cargo, Intercity (localization keys)
    private let categories: [Category] = [
        Category(icon: "🕐", title: "category.all",       key: .all),
        Category(icon: "🚕", title: "category.taxi",      key: .taxi),
        Category(icon: "🚚", title: "category.cargo",     key: .cargo),
        Category(icon: "📍", title: "category.intercity", key: .intercity)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            categoryScrollView
        }
        .onAppear { }
        .padding(.vertical)
    }
    
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selected == category.key
                    ) {
                        selected = category.key
                    }
                }
            }
            .padding(.horizontal,20)
        }
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(category.icon)
                    .font(.system(size: 20))
                
                Text(category.title.localize)
                    .font(.system(size: 17, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .foregroundColor(textColor)
        }
    }
    
    private var backgroundColor: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(isSelected ? Color.iPrimary : Color.secondaryBackground)
    }
    
    private var textColor: Color {
        isSelected ? .white : .primary
    }
}
