//
//  PaymentMethodView.swift
//  Ildam
//
//  Created by Sardorbek Saydamatov on 20/11/24.
//

import SwiftUI
import IldamSDK
import Core
import YallaUtils

struct PaymentMethodsView: View {
    @State private var addCardView: Bool = false
    @State private var selectedRowId: String?
    @StateObject private var viewModel = PaymentMethodsViewModel()
    
    var body: some View {
        PageableScrollView(
            title: viewModel.pageTitle,
            onReachedBottom: {}, content: {
                VStack(alignment: .leading, spacing: 0) {
                    bonusRow
                    
                    // Наличные
                    cashRow
                        .visibility(
                            !viewModel.isEditing
                        )
                    
                    cardList
                    
                    addCardRow
                        .visibility(
                            !viewModel.isEditing
                        )
                }
            }
        )
        .animation(.easeInOut, value: viewModel.isEditing)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleEditMode()
                } label: {
                    Text(
                        viewModel.isEditing ? "done".localize : "edit".localize
                    )
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                }
                .visibility(viewModel.canEdit)
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.addCardView) {
            AddCardView()
        }
        .onAppear {
            self.viewModel.onAppear()
        }
    }
}

extension PaymentMethodsView {
    
    private var bonusRow: some View {
        HStack(spacing: 16.scaled) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 44.scaled, height: 44.scaled)
                .foregroundStyle(.iBackgroundSecondary)
                .overlay {
                    Image("icon_gold_coin")
                }
            
            VStack(alignment: .leading) {
                Text("bonus".localize)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.label)
                
                Text("you.have.n.bonus".localize(arguments: 0.description))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.label)
            }
            
            Spacer()
            
            SwitchViewFactory.default(isOn: .constant(false))
        }
        .padding(.horizontal, AppParams.Padding.default)
        .frame(height: 60)
        .onTapped(.background) {
            
        }
    }
    
    private var cashRow: some View {
        row(
            title: "cash".localize,
            icon: "icon_cash3d",
            isSelected: viewModel.selectedPaymentMethodId == "cash",
            renderingMode: .original
        )
        .padding(.horizontal, AppParams.Padding.default)
        .frame(height: 60)
        .onTapped(.background) {
            viewModel.selectPaymentMethod("cash")
        }
        .disabled(!viewModel.isCashEnabled)
    }
   
    private var addCardRow: some View {
        row(
            title: "add.card".localize,
            icon: "icon_add",
            isSelected: false
        )
        .padding(.horizontal, AppParams.Padding.default)
        .frame(height: 60)
        .onTapped(.background) {
            viewModel.openAddCardView()
        }
        .visibility(viewModel.isCardEnabled)
    }
    
    @ViewBuilder
    private func row(
        title: String,
        icon: String,
        isSelected: Bool,
        renderingMode: Image.TemplateRenderingMode = .template
    ) -> some View {
        HStack(spacing: 16.scaled) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 44.scaled, height: 44.scaled)
                .foregroundStyle(.iBackgroundSecondary)
                .overlay {
                    Image(icon)
                        .resizable()
                        .renderingMode(renderingMode)
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .frame(width: 24)
                }
            
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.label)
            
            Spacer()
            
            if isSelected {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.iPrimary)
                    .overlay {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 8, height: 11)
                            .foregroundStyle(.white)
                    }
            }
        }
        .frame(height: 32)
    }
}

extension PaymentMethodsView {
    private var cardList: some View {
        ForEach(viewModel.cards, id: \.cardId) { card in
            HStack {
                row(
                    title: card.miniPan,
                    icon: card.type.iconName,
                    isSelected: viewModel.isEditing ? false : viewModel.isSelected(card.cardId),
                    renderingMode: .original
                )
                
                Image("icon_trash")
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
                    .visibility(viewModel.isEditing)
            }
            .padding(.horizontal, AppParams.Padding.default)
            .frame(height: 60)
            .onTapped(.background) {
                if viewModel.isEditing {
                    viewModel.deleteCard(card.cardId)
                } else {
                    viewModel.selectPaymentMethod(card.cardId)
                }
            }
            .overlay(content: {
                if !viewModel.isEditing {
                    Rectangle()
                        .foregroundStyle(Color.background.opacity(0.5))
                        .visibility(!viewModel.isCardEnabled)
                }
            })
            .disabled(!viewModel.isCardEnabled)
        }
    }
}

#Preview {
    NavigationStack {
        PaymentMethodsView()
    }
}
