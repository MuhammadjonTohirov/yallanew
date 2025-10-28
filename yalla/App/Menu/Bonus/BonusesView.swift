//
//  BonusView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 27/10/25.
//

import Foundation
import SwiftUI
import Core
import Combine
import YallaUtils

final class BonusesViewModel: ObservableObject {
    @Published var bonus: String = ""
    @Published var promocode: String = ""
    
    func onAppear() {
        bonus = UserSettings.shared.userInfo?.balance?.asMoney ?? "0"
    }
}

struct BonusesView: View {
    @StateObject private var viewModel = BonusesViewModel()
    @State private var showPromocodeView: Bool = false
    
    var body: some View {
        innerBody
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            bonusView
            
            promocodeView
        }
        .scrollable()
        .appSheet(isPresented: $showPromocodeView, title: "promocode".localize, sheetContent: {
            promocodeSetupView
        })
        .navigationTitle("bonus.and.promocodes".localize)
        .onAppear {
            self.viewModel.onAppear()
        }
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
                showPromocodeView = true
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
            
            Text("promocode.descr".localize)
                .font(.bodyBaseMedium)
                .multilineTextAlignment(.center)
            
            SubmitButtonFactory.primary(
                title: "activate".localize,
                action: {
                    showPromocodeView = false
                }
            )
            .padding(.horizontal, AppParams.Padding.large)
        }
    }
}

#Preview {
    NavigationStack {
        BonusesView()
    }
}
