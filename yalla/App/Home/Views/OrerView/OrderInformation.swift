//
//  OrderInformation.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 11/11/25.
//

import SwiftUI
import YallaUtils
import Core

struct OrderInformationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            progressView
            addressView
            tariffView
            paymentTypeView
            footerView
            Spacer()
            cancelOrder
        }
        .padding(.horizontal, AppParams.Padding.default)
    }
    private var progressView: some View {
        VStack(spacing: 16) {
           HStack {
               Text(verbatim: "Больше 7 машин рядом")
                   .font(.bodyBaseBold)
                    .foregroundColor(.iLabel)
               
               Spacer()
               Text("11:33")
                   .font(.bodyBaseBold)
                   .foregroundColor(.iLabel)
            }
            
            FlowProgressView(
            progress: 0.6,
            fillGradient:  LinearGradient(
                colors: [.red, .iPrimaryDark],
                startPoint: .leading,
                endPoint: .trailing
            ),
            trackColor: Color.iBackgroundTertiary
                )
        }
        .padding(.vertical, AppParams.Padding.default)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .fill(Color.iBackgroundSecondary)
        }
    }
    
    private var addressView: some View {
        VStack {
            HStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width: 18, height: 10)
                    .foregroundStyle(Color.iPrimary)
                
                Text(verbatim: "Авиасозлар 1-й квартал")
                    .font(.bodyBaseBold)
                
                Spacer()
                
            }
            .padding(.vertical, AppParams.Padding.small)
 
            Divider()
            
            HStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width: 16.scaled, height: 10)
                    .foregroundStyle(Color.red)
                
                Text(verbatim: "Афроисаб 18")
                    .font(.bodyBaseBold)
                
                Spacer()
                
                Image.icon("icon_add_circle")
                    .aspectRatio(contentMode: .fit)
                
                
            }
            .padding(.vertical, AppParams.Padding.small)
             
        }
        .padding(.vertical, AppParams.Padding.default)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .fill(Color.iBackgroundSecondary)
        }
    }
    
    private var tariffView: some View {
        
        HStack(spacing: 20) {
            Text(verbatim: "Тариф:  Стандарт")
                .font(.bodyBaseBold)
            Spacer()
           
            ZStack {
               
               Image("image_right_arrrow")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(width: 160)
                   .padding(.leading)

               Image("image_tariff_car")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(maxWidth: 100,alignment: .trailing)
                   .horizontal(alignment: .trailing)
 
            }
             .clipShape(RoundedRectangle(cornerRadius: AppParams.Radius.default))
             .frame(height: 60)

               
        }
        .padding(.leading)
         .background {
            
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .fill(Color.iBackgroundSecondary)
        }
    }
    
    private var paymentTypeView: some View {
        HStack {
           HStack(spacing: 12) {
                Image("icon_cash3d")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(verbatim: "Оплата наличными:")
                    .font(.bodyBaseBold)
                    .foregroundColor(Color.iLabel)
            }
           .padding(.horizontal, AppParams.Padding.small)

            Spacer()
            
            Text(verbatim: "73.000 сум")
                .font(.bodyBaseBold)
                .foregroundColor(Color.iLabel)
            
        }
        .padding(.vertical, AppParams.Padding.default)
        .padding(.horizontal, AppParams.Padding.default)
        .background {
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .fill(Color.iBackgroundSecondary)
        }
    }
    
    private var footerView: some View {
        HStack(spacing: 10) {
            Image.icon("icon_add_circle")
                .aspectRatio(contentMode: .fill)
                    
            Text(verbatim: "Заказать еще")
                .font(.bodySmallMedium)
                .foregroundColor(Color.iLabel)
            
            Spacer()
            
            Image.icon("icon_arrow_right")
               
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: AppParams.Radius.default)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.iBorderDisabled)
        )
    }
    private var cancelOrder: some View {
        VStack {
             
            SubmitButton(
                backgroundColor: Color.iButtonTertiary, pressedColor: Color.iButtonTertiaryDisabled,
                height: 60) {
                    HStack(spacing: 10) {
                        
                        Image.icon("icon_close_circle", color: Color.background)
                            .aspectRatio(contentMode: .fit)
 
                        Text("Отменить заказ")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.background)
                    }

                } action: {
                    
            }
        }
    }

}

#Preview {
    OrderInformationView()
}
 

