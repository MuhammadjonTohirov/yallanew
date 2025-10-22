//
//  HomeSavedAddressesCardViewModel.swift
//  yalla
//
//  Created by OpenAI on 24/10/25.
//

import Foundation
import Combine

@MainActor
final class HomeSavedAddressesCardViewModel: ObservableObject {
    struct SavedAddress: Identifiable, Equatable {
        enum Icon {
            case home
            case work
            case custom(systemName: String)
            
            var systemName: String {
                switch self {
                case .home:
                    return "house.fill"
                case .work:
                    return "briefcase.fill"
                case let .custom(systemName):
                    return systemName
                }
            }
        }
        
        let id: UUID
        let title: String
        let subtitle: String
        let eta: String?
        let icon: Icon
        
        init(
            id: UUID = UUID(),
            title: String,
            subtitle: String,
            eta: String? = nil,
            icon: Icon = .custom(systemName: "mappin.circle.fill")
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.eta = eta
            self.icon = icon
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    enum State: Equatable {
        case empty
        case single(SavedAddress)
        case multiple([SavedAddress])
    }
    
    @Published var addresses: [SavedAddress]
    
    init(addresses: [SavedAddress] = []) {
        self.addresses = addresses
    }
    
    var state: State {
        switch addresses.count {
        case 0:
            return .empty
        case 1:
            return .single(addresses[0])
        default:
            return .multiple(addresses)
        }
    }
}
