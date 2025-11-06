//
//  SelectLanguageView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

struct SelectLanguageView: View {
    @StateObject
    private var viewModel = SelectLanguageViewModel()
    
    @State
    private var startPoint: UnitPoint = .topLeading
    
    @State
    private var showSheet: Bool = false
    
    @State
    private var selectedLanguage: String = "uz"
    
    @State
    private var showSecondImage: Bool = false
    
    @StateObject
    private var navigator: Navigator = Navigator()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            innerBody
                .navigationDestination(for: SelectLanguageRoute.self) { route in
                    route.scene
                        .environmentObject(navigator)
                }
                .onAppear {
                    Task { @MainActor in
                        await viewModel.setNavigator(navigator)
                    }
                }
        }
    }
    
    var innerBody: some View {
        ZStack {
            Color.iPrimary
            .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: .iPrimaryLite.opacity(1), location: 0),
                .init(color: .iPrimaryDark.opacity(1), location: 1),
            ], center: startPoint, startRadius: 0, endRadius: 500)
            .ignoresSafeArea()

            VStack {
                ZStack {
                    Image("splash_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 193, height: 121)
                        .scaleEffect(0.9)
                        .opacity(!showSecondImage ? 1 : 0)
                    
                    Image("icon_logo_flat")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: showSheet ? 117 : 154.46, height: showSheet ? 64.5 : 98.7)
                        .scaleEffect(0.9)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                        .opacity(showSecondImage ? 1 : 0)
                }
                .padding(.vertical, 52)
                .padding(.top, showSheet ? 55.scaled : 0)

                if showSheet {
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .overlay {
            VStack {
                if showSheet {
                    Rectangle()
                        .transition(.push(from: .bottom).combined(with: .identity))
                        .foregroundStyle(Color.background)
                        .cornerRadius(40, corners: [.topLeft, .topRight])
                        .ignoresSafeArea(.container, edges: .bottom)
                        .overlay {
                            sheetView
                        }
                        .padding(.top, 174.scaled + UIApplication.shared.safeArea.top)
                }
            }
        }

        .onAppear {
            withAnimation {
                showSecondImage = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    startPoint = .top
                    showSheet = true
                }
            }
        }
    }
    
    private var languagesView: some View {
        VStack(spacing: 18.scaled) {
            LanguageRowView(language: LanguageUz(), selected: .init(get: {
                selectedLanguage == LanguageUz().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageUz())
                }
            }))
            
//            LanguageRowView(language: LanguageUzCryl(), selected: .init(get: {
//                selectedLanguage == LanguageUzCryl().code
//            }, set: { selected in
//                if selected {
//                    selectLanguage(LanguageUzCryl())
//                }
//            }))
            
            LanguageRowView(language: LanguageRu(), selected: .init(get: {
                selectedLanguage == LanguageRu().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageRu())
                }
            }))
            
//            LanguageRowView(language: LanguageEn(), selected: .init(get: {
//                selectedLanguage == LanguageEn().code
//            }, set: { selected in
//                if selected {
//                    selectLanguage(LanguageEn())
//                }
//            }))
        }
    }
    
    private func selectLanguage(_ language: any LanguageProtocol) {
        UserSettings.shared.language = language.code
        
        selectedLanguage = language.code
    }
    
    private var sheetView: some View {
        VStack(spacing: 52.scaled) {
            Text("select.app.lang".localize)
                .font(.titleBaseBold)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .frame(minHeight: 48, alignment: .center)
            
            languagesView
            
            SubmitButtonFactory.primary(
                title: "select".localize(language: self.selectedLanguage)
            ) {
                Task {
                    try? await viewModel.selectLanguage(self.selectedLanguage)
                }
            }
            .id(UserSettings.shared.language)
        }
        .padding(.horizontal, 30.scaled)
        .padding(.top, 52.scaled)
    }
}

#Preview {
    SelectLanguageView()
}
