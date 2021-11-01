//
//  ContentView.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import CoreData
import SwiftUI

struct AppMainView: View {
    @State var selectedIndex = 1
    @State private var selectedID = ""
    @StateObject private var object = VenuesViewModel()
    var body: some View {
        VStack {
            Picker(selection: $selectedIndex, label: Text("Nearby Venues"), content: {
                Text("Nearby Venues").tag(1)
                Text("Venue Details").tag(2)
            }).pickerStyle(.segmented)

            if selectedIndex == 1 {
                VenuesListView(viewModel:  object) { id in
                    self.selectedID = id
                    self.selectedIndex = 2
                }
            } else {
                VenueDetailView(viewModel: VenueDetailViewModel(id: selectedID))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppMainView()
    }
}
