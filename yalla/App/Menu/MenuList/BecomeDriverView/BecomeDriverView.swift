//
//  BecomeDriverView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 27/10/25.
//

import SwiftUI
import Core
import YallaUtils

struct BecomeDriverView: View {
    @State private var nameText: String = ""
    @State private var phoneText: String = ""
    @State private var regionText: String = ""

    private enum Field: Hashable { case name, phone, region }
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack (alignment: .leading,spacing: 6) {
            headerView
            middleView
            
            Spacer()
            
            SubmitButton(backgroundColor: .iPrimary) {
                Text("submit.application".localize)
                    .font(.system(size: 16, weight: .bold))
                
            } action: {
            }
        }
        .padding(.horizontal)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("become.driver".localize)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.iLabel)
            
            Text("become.driver.descr".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.iLabel)
        }
    }
    
    private var middleView: some View {
        
        VStack(spacing: 10) {
            YRoundedTextField {
                HStack {
                    YPhoneField(
                        text: $nameText,
                        font: .bodyBaseMedium,
                        placeholder: "Ваше имя".localize
                    )
                }.padding(.horizontal, AppParams.Padding.medium)
                    .frame(height: 50)
            }
            .set(borderColor: focusedField == .name ? .label : .iBorderDisabled)
            .focused($focusedField, equals: .name)
            
            YRoundedTextField {
                HStack {
                    Text("+998".localize)
                        .font(.bodyBaseMedium)
                        .padding(.leading, AppParams.Padding.medium)
                    Divider()
                        .frame(height: 38)
                    YPhoneField(
                        text: $phoneText,
                        font: .bodyBaseMedium,
                        placeholder: "(__) ___  __  __"
                    )
                }.padding(.horizontal, AppParams.Padding.medium)
                    .frame(height: 50)
            }
            .set(borderColor: focusedField == .phone ? .label : .iBorderDisabled)
            .focused($focusedField, equals: .phone)
            
            YRoundedTextField {
                HStack {
                    YPhoneField(
                        text: $regionText,
                        font: .bodyBaseMedium,
                        placeholder: "Ваш регион".localize
                    )
                }.padding(.horizontal, AppParams.Padding.medium)
                    .frame(height: 50)
            }
            .set(borderColor: focusedField == .region ? .label : .iBorderDisabled)
            .focused($focusedField, equals: .region)
          

        }
        .padding(.vertical)
    }
}

#Preview {
    BecomeDriverView()
}
