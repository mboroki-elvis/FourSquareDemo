//
//  LocationsViewModel.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Combine
import Foundation

final class VenuesViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    // MARK: Internal

    @Published private(set) var state = State.idle

    func send(event: Event) {
        input.send(event)
    }

    // MARK: Private

    private var bag = Set<AnyCancellable>()

    private let input = PassthroughSubject<Event, Never>()
}

// MARK: - Inner Types

extension VenuesViewModel {
    enum State {
        case idle
        case loading
        case loaded([VenueData])
        case error(Error, [VenueData])
    }

    enum Event {
        case onAppear
        case onSelectVenue(Int)
        case onVenuesLoaded([VenueData])
        case onNetworkErrorGetSaved(Error, [VenueData])
    }
}

// MARK: - State Machine

extension VenuesViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onNetworkErrorGetSaved(let error, let data):
                Logger.shared.log(error, #file, #line)
                return .error(error, data)
            case .onVenuesLoaded(let venues):
                return .loaded(venues)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }

    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            let coordinates = LocationManager.shared.currentLocation?.coordinate
            return FourSquareAPI.places(lat: coordinates?.latitude ?? 40.74224, long: coordinates?.longitude ?? -73.99386)
                .map { VenueDataHandler.saveAndReturnData(response: $0) }
                .map(Event.onVenuesLoaded)
                .catch { Just(Event.onNetworkErrorGetSaved($0, VenueDataHandler.getData())) }
                .eraseToAnyPublisher()
        }
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
