//
//  OnboardingView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 07/11/25.
//

import Foundation
import Core
import SwiftUI
import YallaUtils

enum OnboardingPages: Int, Identifiable, CaseIterable {
    var id: Int { self.rawValue }
    
    case page1 = 1
    case page2
    case page3
    case page4
    
    var title: String {
        switch self {
        case .page1:
            return "onboarding.page1.title".localize
        case .page2:
            return "onboarding.page2.title".localize
        case .page3:
            return "onboarding.page3.title".localize
        case .page4:
            return "onboarding.page4.title".localize
        }
    }
    
    var detail: String {
        switch self {
        case .page1:
            return "onboarding.page1.detail".localize
        case .page2:
            return "onboarding.page2.detail".localize
        case .page3:
            return "onboarding.page3.detail".localize
        case .page4:
            return "onboarding.page4.detail".localize
        }
    }
    
    var imageName: String {
        "img_onboarding_\(self.rawValue)"
    }
    
    var imageWidth: CGFloat {
        UIApplication.shared.screenFrame.width
    }
}

struct OnboardingView: View {
    @State
    private var pages: [OnboardingPages] = OnboardingPages.allCases
    @State
    private var selectedPageIndex: Int = 0
    
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme
    
    private var backgroundColor: Color {
        self.colorScheme == .dark ? Color(hex: "#1A1A20") : Color(.systemBackground)
    }
    
    private var isLastPage: Bool {
        self.selectedPageIndex == self.pages.count - 1
    }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedPageIndex) {
                ForEach(self.pages.indices, id: \.self) { index in
                    let page = pages[index]
                    VStack {
                        Image(page.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: page.imageWidth,
                            )
                            .frame(maxHeight: .infinity)
                        
                        VStack(spacing: 10.scaled) {
                            Text(page.title)
                                .font(.titleLargeBold)
                            Text(page.detail)
                                .font(.bodySmallMedium)
                        }
                        .multilineTextAlignment(.center)
                        .frame(width: 360.scaled)
                        .padding(.bottom, AppParams.Padding.extraLarge)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            SubmitButtonFactory.primary(title: "continue".localize) {
                guard isLastPage else {
                    finish()
                    return
                }
                
                withAnimation {
                    selectedPageIndex = (selectedPageIndex + 1).limitTop(self.pages.count - 1)
                }
            }
            .padding([.horizontal], AppParams.Padding.default)
            .padding(.bottom, AppParams.Padding.medium)
        }
        .background(backgroundColor.ignoresSafeArea())
        .overlay {
            PagingIndicatorView(pageCount: pages.count, currentPage: selectedPageIndex)
                .animation(.spring, value: selectedPageIndex)
                .vertical(alignment: .bottom)
                .padding(.bottom, 210.scaled)
        }
        .onChange(of: selectedPageIndex, perform: { newValue in
            if newValue == self.pages.count - 1 {
                setOnboardingFlag()
            }
        })
        .overlay {
            Button {
                finish()
            } label: {
                Text("skip".localize)
                    .font(.bodyCaptionMedium)
                    .foregroundStyle(.iLabelSubtle)
            }
            .glassyButtonSyle
            .capsuleBackground(!isIOS26)
            .vertical(alignment: .top)
            .horizontal(alignment: .trailing)
            .padding(.horizontal, AppParams.Padding.default)
            .padding(.top, AppParams.Padding.medium)
        }
    }
    
    @MainActor
    private func setOnboardingFlag() {
        UserSettings.shared.didShowOnboarding = true
    }
    
    @MainActor
    private func finish() {
        UserSettings.shared.didShowOnboarding = true
        mainModel?.navigate(to: .intro)
    }
}

#Preview {
    OnboardingView()
}
