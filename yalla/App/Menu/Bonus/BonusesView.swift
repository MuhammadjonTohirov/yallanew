//
//  BonusView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 27/10/25.
//

import SwiftUI
import Core
import Combine
import YallaUtils
import YallaKit

struct BonusesView: View {
    @StateObject private var viewModel = BonusesViewModel()
    var body: some View {
        innerBody
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            bonusView
            
            promocodeView
        }
        .scrollable()
        .appSheet(isPresented: $viewModel.showPromocodeView, title: "promocode".localize, sheetContent: {
            promocodeSetupView
        })
        .navigationTitle("bonus.and.promocodes".localize)
        .onAppear {
            self.viewModel.onAppear()
        }
        // Snackbar feedback handled in ViewModel
    }
    
    private var bonusView: some View {
        Image("img_bonus_background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay {
                VStack(alignment: .leading) {
                    Text("bonus".localize)
                        .font(.bodyBaseMedium)
                    Text("bonus.conversion.rate".localize)
                        .font(.bodySmallMedium)
                    Spacer()
                    Text(viewModel.bonus)
                        .font(.system(size: 35, weight: .heavy, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundStyle(.white)
                .padding()
            }
            .cornerRadius(16, corners: .allCorners)
            .padding(AppParams.Padding.large.scaled)
    }
    
    private var promocodeView: some View {
        row(icon: Image("icon_ticket_discount"), title: "enter.promocode".localize)
            .frame(height: 60.scaled)
            .padding(.horizontal, AppParams.Padding.default.scaled)
            .background {
                RoundedRectangle(cornerRadius: AppParams.Radius.default.scaled)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.iBorderDisabled)
            }
            .padding(.horizontal, AppParams.Padding.large)
            .onTapGesture {
                viewModel.showPromocodeView = true
            }
    }
    
    private func row(icon: Image, title: String, detail: String = "") -> some View {
        HStack(spacing: AppParams.Padding.medium) {
            icon
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.inter(.medium, size: 16))
                Text(detail)
                    .visibility(!detail.isEmpty)
                    .font(.inter(.regular, size: 12))
            }
            
            Spacer()
            
            Image(systemName: "chevron.forward")
                .foregroundStyle(Color.secondary)
        }
        .foregroundStyle(Color.label)
        .frame(height: 60)
    }
    
    private var promocodeSetupView: some View {
        ZStack {
            VStack(spacing: AppParams.Padding.extraLarge.scaled) {
                Text("enter.promocode".localize)
                    .font(.titleLargeBold)
                
                TextField(text: $viewModel.promocode) {
                    Text("enter.code".localize)
                }
                .foregroundStyle(.iLabelSubtle)
                .font(.bodyBaseMedium)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50.scaled)
                .background {
                    RoundedRectangle(cornerRadius: AppParams.Padding.default.scaled)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.iBorderDisabled)
                }
                .padding(.horizontal, AppParams.Padding.large.scaled)
                .disabled(viewModel.isLoading)
                
                Text("promocode.descr".localize)
                    .font(.bodyBaseMedium)
                    .multilineTextAlignment(.center)
                
                SubmitButtonFactory.primary(
                    title: "activate".localize,
                    action: {
                        viewModel.applyPromocode()
                    }
                )
                .set(isEnabled: !viewModel.promocode.isEmpty && !viewModel.isLoading)
                .padding(.horizontal)

            }
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")

        }
    }
}

#Preview {
    NavigationStack {
        BonusesView()
    }
}
