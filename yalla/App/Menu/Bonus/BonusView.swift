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
    
    func onAppear() {
        bonus = UserSettings.shared.userInfo?.balance?.asMoney ?? ""
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
            Text("promocode.descr".localize)
                .font(.inter(.regular, size: 12))
                .foregroundStyle(Color.secondary)
                .padding(.bottom, AppParams.Padding.default)
            
            bonusView
            
            promocodeView
                .visibility(false)
        }
        .scrollable()
        .navigationDestination(isPresented: $showPromocodeView) {
            Text("")
        }
        .onAppear {
            self.viewModel.onAppear()
        }
    }
    
    private var bonusView: some View {
        Image("img_bonus_background")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(AppParams.Padding.large.scaled)
            .overlay {
                
            }
    }
    
    private var promocodeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("promo_codes".localize)
                .font(.inter(.bold, size: 20))
                .frame(height: 60)
            
            row(icon: Image("icon_coupon"), title: "enter_promocode".localize)
        }
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
                .foregroundStyle(Color.secondary)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.inter(.medium, size: 16))
                Text(detail)
                    .visibility(!detail.isEmpty)
                    .font(.inter(.regular, size: 12))
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.forward")
                .foregroundStyle(Color.secondary)
        }
        .frame(height: 60)
    }
}

#Preview {
    NavigationStack {
        BonusesView()
    }
}
