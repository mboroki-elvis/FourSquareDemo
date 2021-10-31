//
//  VenuesListView.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Combine
import SwiftUI

struct VenuesListView: View {
    // MARK: Internal

    @ObservedObject var viewModel: VenuesViewModel
    var onSelect: (_ id: String) -> Void

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Nearby Venues")
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
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(_, let locations):
            return list(of: locations).eraseToAnyView()
        case .loaded(let locations):
            return list(of: locations).eraseToAnyView()
        }
    }

    private func list(of locations: [VenueData]) -> some View {
        List(locations) { location in
            VenuesListItemView(location: location).onTapGesture {
                guard let id = location.id else {
                    return
                }
                onSelect(id)
            }
        }
    }
}
