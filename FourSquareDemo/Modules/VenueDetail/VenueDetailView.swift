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
        content
            .onAppear { self.viewModel.send(event: .onAppear) }
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
                
                Text(data.name ?? "")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                             
                Divider()

                HStack {
                    Text(data.location?.address ?? "")
                    Text(data.location?.crossStreet ?? "")
                    Text(data.location?.city ?? "")
                }
                .font(.subheadline)
                
                poster(of: data.categories)
                                
                genres(of: data.categories)
                
                Divider()

                Text(data.location?.formattedAddress ?? "").font(.body)
            }
        }
    }
    
    private func poster(of location: NSSet?) -> some View {
        let url = getCatagories(data: location)?
            .first { $0.iconPath != nil }
            .map { URL(string: $0.iconPath ?? "https://via.placeholder.com/300") }
        return AsyncImage(
            url: url!!,
            cache: cache,
            placeholder: spinner,
            configuration: { $0.resizable().renderingMode(.original) }
        )
        .aspectRatio(contentMode: .fit)
    }
    
    private func genres(of data: NSSet?) -> some View {
        let categories = getCatagories(data: data)?.map { $0.pluralName } ?? []
        return HStack {
            ForEach(categories, id: \.self) { genre in
                Text(genre ?? "Uknown")
                    .padding(5)
                    .border(Color.gray)
            }
        }
    }
    
    private func getCatagories(data: NSSet?) -> [VenueCategory]? {
        return Array(data ?? []) as? [VenueCategory]
    }
}
