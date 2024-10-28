//
//  SettingsView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var isFeedbackSheetPresented: Bool = false

    var body: some View {
        HStack {
            Text("Settings")
                .font(.title3)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .clipped()
        }
        .padding()

        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("App")
                            .font(.callout)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Image(systemName: "message.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Contact Us")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Leave a Review")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Give Feedback")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                    .onTapGesture {
                        isFeedbackSheetPresented = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Legal")
                            .font(.callout)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "book.pages.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Terms of Service")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                    HStack {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Privacy Policy")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Account")
                            .font(.callout)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Manage Subscription")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                        Text("Sign Out")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .clipped()
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .init(horizontal: .trailing, vertical: .center)) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 30)
                            .opacity(0.35)
                            .offset(x: -8)
                    }
                    // .background(Color(hex: 0x181818))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                            .opacity(0.05)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .padding()
        .sheet(isPresented: $isFeedbackSheetPresented) {
            Text("Feedback")
        }
    }
}

#Preview {
    SettingsView()
}
