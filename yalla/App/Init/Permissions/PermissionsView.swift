//
//  PermissionsView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct PermissionsView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = PermissionsViewModel()
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                backgroundGradient
                
                VStack(spacing: 0) {
                    // Logo at top
                    logoSection
                        .padding(.top, geometry.safeAreaInsets.top + AppParams.Padding.large)
                    
                    // Title and description
                    titleView
                    
                    // Main permission card
                    permissionCard(geometry: geometry)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .hideBackButton()
    }
    
    private var titleView: some View {
        // Title and description
        VStack(alignment: .leading, spacing: AppParams.Padding.medium) {
            Text(LocalizedStringKey(viewModel.permissionTitle))
                .font(.titleXLargeBold)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            Text(LocalizedStringKey(viewModel.permissionDescription))
                .font(.bodySmallRegular)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 29.scaled)
        .padding(.horizontal, AppParams.Padding.large)
    }
}

// MARK: - View Components

private extension PermissionsView {
    
    var backgroundGradient: some View {
        ZStack {
            Color.iPrimaryDark.ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: Color.iPrimaryLite, location: 0),
                .init(color: Color.iPrimaryDark, location: 1)
            ], center: .top, startRadius: 0, endRadius: 300)
        }
    }
    
    var logoSection: some View {
        Image("icon_logo_flat")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 74)
    }
    
    func permissionCard(geometry: GeometryProxy) -> some View {
        VStack(spacing: AppParams.Padding.large) {
            Spacer()
            
            // Permission icon
            Image(viewModel.permissionImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240.scaled, height: 240.scaled)
                .padding(.top, AppParams.Padding.large)
            
            Spacer()
                    
            // Allow button at bottom
            actionButton
                .padding(.horizontal, AppParams.Padding.large)
                .padding(.bottom, geometry.safeAreaInsets.bottom + AppParams.Padding.large)
        }
        .background(
            RoundedRectangle(cornerRadius: AppParams.Radius.large)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .opacity(viewModel.isRequesting ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isRequesting)
    }
    
    var actionButton: some View {
        VStack(spacing: AppParams.Padding.medium) {
            // Main allow button
            SubmitButtonFactory.primary(title: viewModel.buttonTitle) {
                viewModel.allowPermission()
            }
            .set(isLoading: viewModel.isRequesting)
            .set(isEnabled: !viewModel.isRequesting)
            
            // Skip button (optional - can be added if needed)
            if viewModel.hasError {
                Button(action: {
                    viewModel.skipPermission()
                }) {
                    Text("permissions.skip.button")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .underline()
                }
                .disabled(viewModel.isRequesting)
            }
        }
    }
}

// MARK: - Error State

private extension PermissionsView {
    
    @ViewBuilder
    var errorOverlay: some View {
        if viewModel.hasError {
            VStack(spacing: AppParams.Padding.medium) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                
                Text(viewModel.errorMessage)
                    .font(.body)
                    .foregroundColor(Color("ILabel"))
                    .multilineTextAlignment(.center)
                
                
                
                Button(action: {
                    viewModel.allowPermission()
                }) {
                    Text("permissions.retry.button")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("IPrimary"))
                        .padding(.horizontal, AppParams.Padding.large)
                        .padding(.vertical, AppParams.Padding.small)
                        .background(
                            RoundedRectangle(cornerRadius: AppParams.Radius.small)
                                .stroke(Color("IPrimary"), lineWidth: 1)
                        )
                }
            }
            .padding(AppParams.Padding.large)
            .background(
                RoundedRectangle(cornerRadius: AppParams.Radius.medium)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
        }
    }
}

// MARK: - Previews

#Preview("Location Permission") {
    UserSettings.shared.language = LanguageUz().code
    return PermissionsView()
}
