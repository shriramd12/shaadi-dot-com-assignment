//
//  ContentView.swift
//  MatchMate
//
//  Created by Shriram Dharmadhikari on 02/09/24.
//

import SwiftUI
import CoreData
import CachedAsyncImage

struct ProfileCardList: View {
    @ObservedObject private var viewModel: ProfileCardListViewModel

    init(networkService: NetworkServiceProtocol,
         viewContext: NSManagedObjectContext) {
        self.viewModel = ProfileCardListViewModel(
            networkService: networkService,
            viewContext: viewContext)
    }

    var body: some View {
        showContainerView().onAppear {
            viewModel.fetchProfiles()
        }
    }

    @ViewBuilder func showContainerView() -> some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else {
            List(viewModel.profileCards, id: \.email) { profile in
                Section {
                    profileCardItem(profile: profile)
                }
            }.refreshable {
                viewModel.fetchProfiles()
            }.toast(isPresented: $viewModel.showToast, message: viewModel.errorMessage, background: .red.opacity(0.8))
        }
    }
    @ViewBuilder func profileCardItem(profile: ProfileCard) -> some View {
        VStack(content: {
            CachedAsyncImage(url: URL(string: profile.imageUrl), content: { image in
                image
            }, placeholder: {
                Image("photo.artframe")
            }).frame(width: 128, height: 128)
                .cornerRadius(6)
            Text(profile.fullName)
                .font(.title)
            Text(profile.address)
                .font(.callout)
                .foregroundStyle(.secondary)

            if let isAccepted = profile.isAccepted {
                HStack {
                    Text(isAccepted ? "Accepted" : "Declined")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .background(isAccepted ? .green : .red, in: .capsule)
            } else {
                HStack(content: {
                    Button(action: {viewModel.update(isAccepted: true, for: profile)}, label: {
                        Image(systemName: "checkmark")
                    })
                    .buttonBorderShape(ButtonBorderShape.circle)
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .controlSize(.large)
                    Spacer()
                    Button(action: {viewModel.update(isAccepted: false, for: profile)}, label: {
                        Image(systemName: "xmark")
                    })
                    .buttonBorderShape(ButtonBorderShape.circle)
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .controlSize(.large)
                })
                .padding(12)
            }
        })
    }
}
