//
//  HomeSavedAddressesCard.swift
//  yalla
//
//  Created by OpenAI on 24/10/25.
//

import SwiftUI
import Core
import YallaUtils

struct HomeSavedAddressesCard: View {
    @ObservedObject var viewModel: HomeSavedAddressesCardViewModel
    var onAddAddress: (() -> Void)?
    var onSelectAddress: ((HomeSavedAddressesCardViewModel.SavedAddress) -> Void)?
    var onManageAddresses: (() -> Void)?
    
    private let cardBackground = Color.iBackgroundSecondary
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .empty:
                emptyStateCard
            case let .single(address):
                HStack(spacing: 10.scaled) {
                    addressCard(for: address)
                    manageButton
                }
            case let .multiple(addresses):
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10.scaled) {
                        ForEach(addresses) { address in
                            addressCard(for: address)
                        }
                        manageButton
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
    
    private var emptyStateCard: some View {
        RoundedRectangle(cornerRadius: 20.scaled, style: .continuous)
            .fill(cardBackground)
            .frame(height: 120.scaled)
            .overlay {
                ZStack(alignment: .bottomTrailing) {
                    Image("img_map_pin")
                        .resizable()
                        .frame(width: 94.scaled, height: 94.scaled)
                        .horizontal(alignment: .leading)
                        .vertical(alignment: .bottom)
                        .padding(.leading, AppParams.Padding.default.scaled)
                    
                    VStack(alignment: .leading, spacing: 12.scaled) {
                        Text("add.address".localize)
                            .font(.bodyBaseBold)
                            .foregroundStyle(Color.primary)
                            .horizontal(alignment: .leading)
                            .vertical(alignment: .top)
                            .padding(.leading, AppParams.Padding.large.scaled)
                            .padding(.top, AppParams.Padding.default.scaled)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    addButton
                        .onClick {
                            onAddAddress?()
                        }
                        .modifier(WaveEffectModifier(largeningPercentage: 1))
                        .padding(10)
                        .zIndex(0)
                }
            }
            .cornerRadius(20, corners: .allCorners)
    }
    
    private func addressCard(for address: HomeSavedAddressesCardViewModel.SavedAddress) -> some View {
        Button {
            onSelectAddress?(address)
        } label: {
            VStack(alignment: .leading, spacing: 12.scaled) {
                HStack(spacing: 7.scaled) {
                    Circle()
                        .fill(Color.iPrimary.opacity(0.1))
                        .frame(width: 28.scaled, height: 28.scaled)
                        .overlay {
                            Image(systemName: address.icon.systemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14.scaled, height: 14.scaled)
                                .foregroundStyle(Color.iPrimary)
                        }
                    
                    Text(address.title)
                        .font(.bodyBaseBold)
                        .foregroundStyle(Color.primary)
                    
                    Spacer(minLength: 0)
                }
                
                Text(address.subtitle)
                    .font(.bodySmallMedium)
                    .foregroundStyle(Color.primary.opacity(0.6))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
                
                if let eta = address.eta, !eta.isEmpty {
                    Text(eta)
                        .font(.bodyBaseBold)
                        .foregroundStyle(Color.primary)
                }
            }
            .padding(.vertical, 17.scaled)
            .padding(.horizontal, 20.scaled)
            .frame(width: 238.scaled, height: 120.scaled, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20.scaled, style: .continuous)
                    .fill(cardBackground)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var manageButton: some View {
        Button {
            onManageAddresses?()
        } label: {
            RoundedRectangle(cornerRadius: 20.scaled, style: .continuous)
                .fill(cardBackground)
                .overlay {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 48.scaled, height: 48.scaled)
                        .overlay {
                            addButton
                        }
                        .modifier(WaveEffectModifier(largeningPercentage: 0.5, waveCount: 2))
                }
                .frame(width: 120.scaled, height: 120.scaled)
                
                .cornerRadius(20.scaled, corners: .allCorners)
        }
        .buttonStyle(.plain)
    }
    
    private var addButton: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 40.scaled, height: 40.scaled)
            .foregroundStyle(Color.iPrimary)
            .background {
                Circle()
                    .padding(0.5)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
            }
    }
}

#if DEBUG
#Preview("Empty state") {
    HomeSavedAddressesCard(
        viewModel: .init(addresses: []),
        onAddAddress: {},
        onSelectAddress: { _ in },
        onManageAddresses: {}
    )
    .padding()
    .background(Color.gray.opacity(0.01))
}

#Preview("Single address") {
    let viewModel = HomeSavedAddressesCardViewModel(
        addresses: [
            .init(
                title: "Домой",
                subtitle: "Авиасозлар 1-й квартал, 29, подъезд 1",
                eta: "27 мин",
                icon: .home
            )
        ]
    )
    
    return HomeSavedAddressesCard(
        viewModel: viewModel,
        onAddAddress: {},
        onSelectAddress: { _ in },
        onManageAddresses: {}
    )
    .padding()
    .background(Color.gray.opacity(0.01))
}

#Preview("Multiple addresses") {
    let viewModel = HomeSavedAddressesCardViewModel(
        addresses: [
            .init(
                title: "Домой",
                subtitle: "Авиасозлар 1-й квартал, 29, подъезд 1",
                eta: "27 мин",
                icon: .home
            ),
            .init(
                title: "Офис",
                subtitle: "Улица Афроисаб 18",
                eta: "12 мин",
                icon: .work
            ),
            .init(
                title: "Университет",
                subtitle: "University Avenue 12, корпус B",
                eta: "18 мин",
                icon: .custom(systemName: "building.columns.fill")
            )
        ]
    )
    
    return HomeSavedAddressesCard(
        viewModel: viewModel,
        onAddAddress: {},
        onSelectAddress: { _ in },
        onManageAddresses: {}
    )
    .padding()
    .background(Color.gray.opacity(0.01))
}
#endif

#Preview("Empty state") {
    HomeSavedAddressesCard(
        viewModel: .init(addresses: []),
        onAddAddress: {},
        onSelectAddress: { _ in },
        onManageAddresses: {}
    )
    .padding()
    .background(Color.gray.opacity(0.01))
}

#Preview("Single address") {
    let viewModel = HomeSavedAddressesCardViewModel(
        addresses: [
            .init(
                title: "Домой",
                subtitle: "Авиасозлар 1-й квартал, 29, подъезд 1",
                eta: "27 мин",
                icon: .home
            )
        ]
    )
    
    return HomeSavedAddressesCard(
        viewModel: viewModel,
        onAddAddress: {},
        onSelectAddress: { _ in },
        onManageAddresses: {}
    )
    .padding()
    .background(Color.gray.opacity(0.01))
}

#Preview("Multiple addresses") {
    let viewModel = HomeSavedAddressesCardViewModel(
        addresses: [
            .init(
                title: "Домой",
                subtitle: "Авиасозлар 1-й квартал, 29, подъезд 1",
                eta: "27 мин",
                icon: .home
            ),
            .init(
                title: "Офис",
                subtitle: "Улица Афроисаб 18",
                eta: "12 мин",
                icon: .work
            ),
            .init(
                title: "Университет",
                subtitle: "University Avenue 12, корпус B",
                eta: "18 мин",
                icon: .custom(systemName: "building.columns.fill")
            )
        ]
    )
    
    return HomeSavedAddressesCard(
        viewModel: viewModel,
        onAddAddress: {},
        onSelectAddress: { _ in },
        onManageAddresses: {}
    )
    .padding()
    .background(Color.gray.opacity(0.01))
}
