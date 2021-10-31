//
//  VenueItemListView.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import SwiftUI

struct VenuesListItemView: View {
    // MARK: Internal

    let location: VenueData
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        HStack {
            category
            VStack(alignment: .leading) {
                title
                details
            }
            Spacer()
            tag
        }
    }

    // MARK: Private

    private var title: some View {
        Text(location.name ?? "")
            .font(.headline)
            .font(.system(size: 14))
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }

    private var category: some View {
        let url = (Array(location.categories ?? []) as? [VenueCategory])?
            .first { $0.iconPath != nil &&  $0.iconPath?.isEmpty == false }
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

    private var details: some View {
        Text(location.location?.formattedAddress ?? "")
            .font(.subheadline)
            .foregroundColor(.gray)
            .font(.system(size: 12))
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }

    private var tag: some View {
        let categories = Array(location.categories ?? []) as? [VenueCategory]
        return Text(categories?.first?.pluralName ?? "")
            .padding()
            .foregroundColor(.white)
            .background(Color.orange)
            .font(.system(size: 10))
            .cornerRadius(.infinity)
            .frame(width: UIScreen.main.bounds.width / 5, alignment: .center)
            .lineLimit(1)
    }

    private var spinner: some View {
        Spinner(isAnimating: true, style: .medium)
    }
}
