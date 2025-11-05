//
//  HistoryDetailsView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 31/10/25.
//

import SwiftUI
import YallaUtils
import Core
import Kingfisher
import IldamSDK

struct HistoryDetailsView: View {
    @StateObject private var viewModel = HistoryDetailsViewModel()
    @State var orderId: Int?
    @State private var isDeleted: Bool = false
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        ScrollView(.vertical) {
           ZStack {
                VStack {
                    userInfo
                    if let item = viewModel.item {
                        adressDetailView(item: item)
                    }
                    supportView
                    
                    if let item = viewModel.item {
                        orderDetail(item: item)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    deletedOrder
                    
                 }
               
               CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")
                   .opacity(viewModel.isLoading ? 1 : 0)
            }
            .onAppear {
                self.viewModel.orderId = orderId
                self.viewModel.onAppear()
            }
        }
        .appSheet(isPresented: $isDeleted) {
            DeleteConfirmationView()
        }
    }
    
    private var userInfo: some View {
        VStack(alignment: .center) {
            driverInfo(item: viewModel.item?.executor)
        }
    }
    func driverInfo(item: TaxiOrderExecutor?) -> some View {
        Group {
            if let item = item {
                VStack(alignment: .center, spacing: 20) {
                    
                    VStack {
                        KFImage(URL(string: item.photo))
                            .placeholder {
                                Circle()
                                    .frame(width: 80.scaled, height: 80.scaled)
                                    .foregroundStyle(Color.iBackgroundTertiary)
                                    .overlay(content: {
                                        Image("icon_user")
                                            .renderingMode(.template)
                                            .foregroundStyle(.iLabel)
                                })
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80.scaled, height: 80.scaled)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    .overlay {
                        Text("driver".localize)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal,10)
                            .padding(.vertical,4)
                            .background {
                                Capsule()
                                    .foregroundStyle(
                                        LinearGradient(colors: [.red, .iPrimaryDark], startPoint: .leading, endPoint: .trailing)
                                )
                            }
                            .vertical(alignment: .bottom)
                            .padding(.bottom,-15)
                    }
                    
                    VStack(alignment: .center, spacing: 2) {
                       HStack (spacing: 8){
                            Text(item.surName)
                                .font(.titleLargeBold)
                                .foregroundStyle(Color.iLabel)
                         
                           Text(item.givenNames)
                               .font(.titleLargeBold)
                               .foregroundStyle(Color.iLabel)
                        }
                        
                        HStack(spacing: 30) {
                            
                            HStack(spacing: 5) {
                                Text(verbatim:"executor.rating:".localize)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(Color.iLabelSubtle)
                                
                               HStack (spacing: 0) {
                                    Text(verbatim:"0")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(Color.iLabel)
                                    
                                    Image("icon_star")
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 23, height: 23)
                                }
                            }
                            
                            HStack(spacing: 5) {
                                
                                Text("executor.trips:".localize)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(Color.iLabelSubtle)
                                
                                Text(verbatim: "0")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(Color.iLabel)
                            }
                        }
                        
                    }
                }
            }
            else {
                emptyView
                    
            }
        }
    }
    func adressDetailView(item: OrderDetails) -> some View {
        VStack {
            Image("img_placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .visibility(item.executor?.driver != nil)

            VStack (alignment: .leading) {
                HStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 8)
                        .foregroundStyle(Color.iPrimary)
                    
                    Text(item.taxi?.fromAddress ?? "")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.iLabel)
                    Spacer()
                }
                
                HStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 8)
                        .foregroundStyle(Color.red)
                    
                    Text(item.taxi?.toAddress ?? "")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.iLabelSubtle)
                    
                }
            }
            .padding(.horizontal,AppParams.Padding.large)
            .padding(.vertical)
        }

        .background(content: {
            RoundedRectangle(cornerRadius: 18)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.iBorderDisabled)
        })
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private func orderDetail(item: OrderDetails) -> some View {
    VStack(spacing: 16) {
    
        HStack {
            Text("trip.details".localize)
            .font(.system(size: 20, weight: .bold))
        Spacer()
    }
        .padding(.trailing)
        .padding(.vertical)

        VStack {
        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text("trip.car".localize)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.iLabelSubtle)
                
                HStack{
                    Text(item.executor?.driver?.color?.colorName ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.iLabel)
                    Text(item.executor?.driver?.model ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.iLabel)
                    Text(item.executor?.driver?.mark ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.iLabel)
                }
            }
            
            Spacer()

            CarNumberView(number: item.executor?.driver?.stateNumber ?? "")
        }
        .visibility(item.executor?.driver?.stateNumber != nil)

        
        Divider()
                .padding(.horizontal, AppParams.Padding.default)
                .visibility(item.executor?.driver?.stateNumber != nil)

        
        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text("trip.tariff".localize)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.iLabelSubtle)
                
                Text(item.taxi?.tariff ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.iLabel)
            }
            Spacer()
        }
        Divider()
            .padding(.horizontal,AppParams.Padding.default)

        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text("payment.method".localize)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.iLabelSubtle)
                
                Text(item.paymentType == "cash" ? "payment.type.cash".localize : "payment.type.card".localize)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.iLabel)
            }
            Spacer()
            Text(item.taxi?.totalPrice?.asMoneySum ?? "0")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.iLabel)
        }
        
        Divider()
                .padding(.horizontal,AppParams.Padding.default)

        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text("trip.date.time".localize)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.iLabelSubtle)
                
                Text(item.dateValue?.string(format: "d MMMM yyyy, HH:mm") ?? "-")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.iLabel)
            }
            Spacer()
        }
    }
        .padding(.all,AppParams.Padding.medium)
        
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.iBorderDisabled)
        }
    }
}
   
    private var emptyView: some View {
        VStack {
            Image("img_declined")
                .resizable()
                .frame(width: 120, height: 120)
                
            Text("trip.canceled.before.search".localize)
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(AppParams.Padding.extraLarge)
         }
    }
    
    private var supportView: some View {
        Button(action: {
            if let url = URL(string: "tel://\(viewModel.phoneNumber)") {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(spacing: 6) {
                Image.icon("icon_headphone")
                    .frame(width: 24, height: 24)
                
                Text("help".localize)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical,8)
         }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.iBorderDisabled)

        }
        .padding(.horizontal)
        .frame(maxHeight: 60)

    }
    
    private var deletedOrder: some View {
       VStack {
            Button(action: {
                isDeleted = true
             }) {
                HStack(spacing: 16) {
                    Image("icon_trash")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                    
                    Text("trip.delete".localize)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.all, 20)
            }
             .background {
                 RoundedRectangle(cornerRadius: 16)
                     .stroke(lineWidth: 1)
                     .foregroundStyle(Color.iBorderDisabled)
                 
             }
             .frame(maxHeight: 60)
             .padding(.horizontal)
        }
        
       .padding(.vertical)

    }
}

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

