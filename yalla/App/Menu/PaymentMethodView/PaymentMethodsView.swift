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
        VStack(alignment: .leading, spacing: 20) {
            Text("cards.and.bonuses".localize)
                .font(.system(size: 20, weight: .bold))
                .horizontal(alignment: .leading)
                .padding(.horizontal, AppParams.Padding.default)
            
            VStack(spacing: 4) {
                bonusRow
                                    
                cardList
            }
            
            addCardRow
                .visibility(
                    !viewModel.isEditing
                )
                .visibility(
                    viewModel.isCardEnabled
                )
            
            cashRow
                .visibility(
                    !viewModel.isEditing
                )
        }
        .scrollable(axis: .vertical)
        .animation(.easeInOut, value: viewModel.isEditing)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleEditMode()
                } label: {
                    Text(
                        viewModel.isEditing ? "exit".localize : "edit".localize
                    )
                    .foregroundStyle(.iTextLink)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .font(.bodySmallBold)
                }
                .visibility(viewModel.canEdit)
            }
        })
        .sheet(isPresented: $viewModel.addCardView) {
            VStack {
                ZStack {
                    DismissCircleButton()
                        .horizontal(alignment: .leading)
                    
                    Text("add.card".localize)
                        .font(.bodyLargeMedium)
                }
                .padding(AppParams.Padding.default.scaled)
                AddCardView()
            }
        }
        .appSheet(isPresented: $viewModel.showEditCardSheet, title: "delete.cards".localize, sheetContent: {
            editCardList
        })
        .onAppear {
            self.viewModel.onAppear()
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("payment.methods".localize)
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
            
            SwitchViewFactory.default(isOn: $viewModel.bonusActive)
        }
        .padding(.horizontal, AppParams.Padding.default)
        .frame(height: 60)
    }
    
    private var cashRow: some View {
        VStack(spacing: 4.scaled) {
            Text("other.methods".localize)
                .font(.system(size: 20, weight: .bold))
                .horizontal(alignment: .leading)
                .padding(.horizontal, AppParams.Padding.default)

            row(
                title: "cash".localize,
                icon: "icon_cash3d",
                isSelected: viewModel.selectedPaymentMethodId == "cash",
                renderingMode: .original
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.background) {
                Task {
                    await viewModel.selectPaymentMethod("cash")
                }
            }
            .frame(height: 60)
            .disabled(!viewModel.isCashEnabled)
        }
    }
   
    private var addCardRow: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
            Text("add.card".localize)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.bodySmallMedium)
        .padding(.horizontal, AppParams.Padding.large)
        .frame(height: 60)
        .background(content: {
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.iBorderDisabled)
        })
        .padding(.horizontal, 2)
        .padding(.horizontal, AppParams.Padding.default)
        .onClick {
            viewModel.openAddCardView()
        }
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
        VStack(spacing: 4) {
            ForEach(viewModel.cards, id: \.cardId) { card in
                let name = card.type.name
                row(
                    title: "\(name) ---- " + card.maskedPan.suffix(4),
                    icon: card.type.newIconName,
                    isSelected: false,
                    renderingMode: .original
                )
                .padding(.horizontal, AppParams.Padding.default)
                .onTapped(.background) {
                    if viewModel.isEditing {
                        viewModel.deleteCard(card.cardId)
                    } else {
                        Task {
                            await viewModel.selectPaymentMethod(card.cardId)
                        }
                    }
                }
                .frame(height: 60.scaled)
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
    
    private var editCardList: some View {
        VStack {
            Text("cards".localize)
                .font(.titleBaseBold)
                .horizontal(alignment: .leading)
            ForEach(viewModel.cards, id: \.cardId) { card in
                let name = card.type.name
                HStack {
                    row(
                        title: "\(name) ---- " + card.maskedPan.suffix(4),
                        icon: card.type.newIconName,
                        isSelected: false,
                        renderingMode: .original
                    )
                    
                    Image("icon_trash")
                        .renderingMode(.template)
                        .foregroundStyle(Color.init(uiColor: .systemRed))
                        .onClick {
                            viewModel.deleteCard(card.cardId)
                        }
                }
                .frame(height: 60)
            }
        }
        .padding(.horizontal, AppParams.Padding.default)
    }
}

extension CardType {
    var newIconName: String {
        switch self {
        case .humo:
            return "icon_humo"
        case .uzcard:
            return "icon_uzcard"
        }
    }
}

#Preview {
    NavigationStack {
        PaymentMethodsView()
    }
}
