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
                    viewModel.isCardEnabled
                )
            
            cashRow
        }
        .scrollable(axis: .vertical)
        .overlay {
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleEditMode()
                } label: {
                    Text("edit".localize)
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
                .alert(isPresented: $viewModel.showDeleteCardAlert) {
                     Alert(
                        title: Text("want.to.delete.card".localize),
                        message: Text("want.to.delete.card.descr".localize),
                        primaryButton: .destructive(
                            Text("delete".localize)
                        ) {
                            Task { @MainActor in
                                await viewModel.deleteCard(viewModel.deletingCardId)
                            }
                        },
                        secondaryButton: .cancel(Text("cancel".localize))
                     )
                }
                .overlay {
                    CoveredLoadingView(isLoading: $viewModel.isDeleting, message: "")
                }
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
        ZStack {
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
                    
                    Text(viewModel.bonusDescription)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.label)
                }
            }
            .horizontal(alignment: .leading)
            .padding(.trailing, 72.scaled)
                    
            SwitchViewFactory.default(isOn: $viewModel.bonusActive)
                .horizontal(alignment: .trailing)
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
        .background {
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .fill(Color.background.opacity(0.001))
        }
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
                        .foregroundStyle(.iLabel)
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
                    isSelected: viewModel.isMainCard(card.cardId),
                    renderingMode: .template
                )
                .padding(.horizontal, AppParams.Padding.default)
                .onTapped(.background) {
                    Task {
                        await viewModel.selectPaymentMethod(card.cardId)
                    }
                }
                .frame(height: 60.scaled)
                .disabled(!viewModel.isCardEnabled)
                .opacity(viewModel.isCardEnabled ? 1.0 : 0.4)
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
                        renderingMode: .template
                    )
                    
                    Image("icon_trash")
                        .renderingMode(.template)
                        .foregroundStyle(Color.init(uiColor: .systemRed))
                        .onClick {
                            Task { @MainActor in
                                await viewModel.deleteCard(card.cardId)
                            }
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
