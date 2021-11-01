//
//  VenueDetailView.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Foundation

import Combine
import SwiftUI

struct VenueDetailView: View {
    // MARK: Internal

    @ObservedObject var viewModel: VenueDetailViewModel
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        NavigationView {
            content
        }
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }

    // MARK: Private

    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return spinner.eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let location):
            return self.location(location).eraseToAnyView()
        }
    }

    private var fillWidth: some View {
        HStack {
            Spacer()
        }
    }

    private var spinner: Spinner { Spinner(isAnimating: true, style: .large) }

    private func location(_ data: VenueData) -> some View {
        ScrollView {
            VStack {
                fillWidth

                HStack {
                    poster(of: data.categories)
                    Text(data.name ?? "")
                        .font(.largeTitle)
                        .multilineTextAlignment(.trailing)
                }

                Divider()

                VStack(alignment: .center) {
                    Spacer()
                    Text("Address: \(data.location?.address ?? "")")
                    Spacer()
                    Text("Cross street: \(data.location?.crossStreet ?? "")")
                    Spacer()
                    Text("Postal code: \(data.location?.postalCode ?? "")")
                    Spacer()
                    Text("City: \(data.location?.city ?? "")")
                    Spacer()
                    Text("Distance from your location: \(data.location?.distance.rounded(.up) ?? 0) Meters")
                }
                .font(.subheadline)

                genres(of: data.categories)
            }
        }
    }

    private func poster(of location: NSSet?) -> some View {
        let url = getCatagories(data: location)?
            .first { $0.iconPath != nil && $0.iconPath?.isEmpty == false }
            .map { URL(string: $0.iconPath ?? "https://via.placeholder.com/300") }
        return AsyncImage(
            url: url!!,
            cache: cache,
            placeholder: spinner,
            configuration: { $0.resizable().renderingMode(.original) }
        )
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50, alignment: .center)
        .cornerRadius(8)
    }

    private func genres(of data: NSSet?) -> some View {
        let categories = getCatagories(data: data)?.map { $0.pluralName } ?? []
        return HStack {
            ForEach(categories, id: \.self) { genre in
                Text(genre ?? "Uknown")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.orange)
                    .font(.system(size: 10))
                    .cornerRadius(.infinity)
            }
        }
    }

    private func getCatagories(data: NSSet?) -> [VenueCategory]? {
        return Array(data ?? []) as? [VenueCategory]
    }
}
