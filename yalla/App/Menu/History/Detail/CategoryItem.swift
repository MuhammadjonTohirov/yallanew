//
//  CategoryItem.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 31/10/25.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

// MARK: - Main View
struct TripCategoryView: View {
    @State private var selectedCategory: Category?
    
    private let categories: [Category] = [
        Category(icon: "🕐", title: "Все"),
        Category(icon: "🚕", title: "Такси"),
        Category(icon: "🚚", title: "Грузовой"),
        Category(icon: "📍", title: "Межгород")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            categoryScrollView
        }
        .onAppear {
            selectedCategory = categories.first
        }
        .padding(.vertical)
    }
    
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory?.id == category.id
                    ) {
                        selectedCategory = category
                    }
                }
            }
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
                
                Text(category.title)
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
            .fill(isSelected ? Color.blue : Color.gray.opacity(0.15))
    }
    
    private var textColor: Color {
        isSelected ? .white : .primary
    }
}

// MARK: - Preview
#Preview {
    TripCategoryView()
}
