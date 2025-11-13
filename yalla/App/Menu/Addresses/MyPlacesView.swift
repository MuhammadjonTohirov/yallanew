//
//  MyPlacesView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 04/11/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core
import IldamSDK

struct MyPlacesView: View {
    @StateObject var viewModel: MyPlacesViewModel = .init()
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.scaled) {
            savedPlacesSection
            
            if !viewModel.others.isEmpty {
                otherPlacesSection
            }
            
            Spacer()
        }
        .padding(.top, 20.scaled)
        .navigationTitle("my.addresses".localize)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Circle()
                    .frame(width: 36.scaled, height: 36.scaled)
                    .foregroundStyle(.iPrimary)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        viewModel.onClickAddNewPlace(type: .other)
                    }
            }
//            .sharedBackgroundVisibility(visible: false)
        })
        .appSheet(isPresented: .init(get: {
            viewModel.sheet != nil
        }, set: { shown in
            if !shown {
                viewModel.sheet = nil
            }
        }), title: viewModel.clickedPlace?.name ?? "", sheetContent: {
            switch viewModel.sheet {
            case .menu:
                menuView
            case .delete:
                ConfirmationSheet(
                    imageName: "icon_trash_bin",
                    title: "attention".localize,
                    bodyText: "want.to.delete.address".localize,
                    buttonTitle: "yes.delete".localize,
                    tapped: {
                        viewModel.onClickDeletePlace()
                    }
                )
            case .none:
                EmptyView()
            }
        })
        .onAppear {
            viewModel.onAppear()
            viewModel.setNavigator(navigator)
        }
        .overlay(content: {
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")
                .ignoresSafeArea()
        })
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: MyPlacesRouter.self) { route in
            route.scene
                .environmentObject(navigator)
        }
    }
    
    private var menuView: some View {
        VStack(spacing: 10.scaled) {
            HStack {
                Image.icon("icon_edit_2")
                Text("update.address")
                    .font(.bodyBaseMedium)
                    .foregroundStyle(.iLabel)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 60.scaled)
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.iBackgroundSecondary) {
                viewModel.onClickEditPlace()
            }
            .clipShape(RoundedRectangle(cornerRadius: AppParams.Radius.default))

            HStack {
                Image.icon("icon_trash", color: Color.red)
                Text("delete.address".localize)
                    .font(.bodyBaseMedium)
                    .foregroundStyle(.iLabel)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 60.scaled)
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.iBackgroundSecondary) {
                viewModel.onClickDeletePlace()
            }
            .clipShape(RoundedRectangle(cornerRadius: AppParams.Radius.default))
        }
        .padding(.horizontal, AppParams.Padding.default)
    }
    
    private var savedPlacesSection: some View {
        HStack(spacing: 10.scaled) {
            savedPlaceCard(
                title: "home".localize,
                subtitle: viewModel.home?.fullAddress ?? "add.address.for.quick.call".localize,
                icon: "icon_house",
                hasAddress: viewModel.home != nil
            ) {
                if let item = viewModel.home {
                    self.viewModel.onClickPlace(item)
                } else {
                    self.viewModel.onClickAddNewPlace(type: .home)
                }
            }
            
            savedPlaceCard(
                title: "work".localize,
                subtitle: viewModel.work?.address ?? "add.address.for.quick.call".localize,
                icon: "icon_briefcase",
                hasAddress: viewModel.work != nil
            ) {
                if let item = viewModel.work {
                    self.viewModel.onClickPlace(item)
                } else {
                    self.viewModel.onClickAddNewPlace(type: .work)
                }
            }
        }
        .padding(.horizontal, AppParams.Padding.large.scaled)
    }
    
    private func savedPlaceCard(
        title: String,
        subtitle: String,
        icon: String,
        hasAddress: Bool,
        tapped: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.titleBaseBold)
                    .foregroundStyle(.iLabel)
                
                Spacer()
                
                iconBadge(icon: icon, hasAddress: hasAddress)
            }
            .padding(.horizontal, 16.scaled)
            .padding(.top, 17.scaled)
            
            Spacer()
            
            Text(subtitle)
                .font(.bodyCaptionMedium)
                .foregroundStyle(hasAddress ? .iLabel : .iLabelSubtle)
                .lineLimit(2)
                .padding(.horizontal, 16.scaled)
                .padding(.bottom, 8.scaled)
        }
        .onTapped(.iBackgroundSecondary) {
            tapped()
        }
        .frame(height: 120.scaled)
        .frame(maxWidth: .infinity)
        .cornerRadius(20.scaled)
    }
    
    private func iconBadge(icon: String, hasAddress: Bool) -> some View {
        RoundedRectangle(cornerRadius: 13.scaled)
            .fill(hasAddress ? Color.iPrimary.opacity(0.15) : Color.iBackgroundTertiary)
            .frame(width: 44.scaled, height: 44.scaled)
            .overlay {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24.scaled, height: 24.scaled)
                    .foregroundStyle(hasAddress ? .iPrimary : .iIconSubtle)
            }
    }
    
    private var otherPlacesSection: some View {
        VStack(spacing: 4.scaled) {
            ForEach(viewModel.others, id: \.id) { place in
                otherPlaceRow(place: place) {
                    viewModel.onClickPlace(place)
                }
            }
        }
    }
    
    private func otherPlaceRow(place: MyPlaceItem, tapped: @escaping () -> Void) -> some View {
        HStack(spacing: 16.scaled) {
            locationIconBadge
            
            VStack(alignment: .leading, spacing: 7.scaled) {
                Text(place.name)
                    .font(.bodyBaseBold)
                    .foregroundStyle(.iLabel)
                
                Text(place.address)
                    .font(.bodySmallMedium)
                    .foregroundStyle(.iLabel)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20.scaled)
        .padding(.vertical, 10.scaled)
        .onTapped {
            tapped()
        }
        .frame(height: 64.scaled)
    }
    
    private var locationIconBadge: some View {
        RoundedRectangle(cornerRadius: 10.scaled)
            .fill(.iBackgroundSecondary)
            .frame(width: 44.scaled, height: 44.scaled)
            .overlay {
                Image("icon_location")
                    .resizable()
                    .frame(width: 20.scaled, height: 20.scaled)
                    .foregroundStyle(.white)
            }
    }
}

private struct MyPlacesPreview: View {
    @StateObject private var navigator: Navigator = .init()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            MyPlacesView()
                .environmentObject(navigator)
        }
    }
}

#Preview {
    MyPlacesPreview()
}
