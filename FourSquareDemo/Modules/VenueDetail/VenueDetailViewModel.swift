//
//  VenueDetailViewModel.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Foundation
import Combine

final class VenueDetailViewModel: ObservableObject {
    @Published private(set) var state: State
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init(id: String) {
        state = .idle(id)
        
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
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types
extension VenueDetailViewModel {
    enum State {
        case idle(String)
        case loading(String)
        case loaded(VenueData)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoaded(VenueData)
        case onFailedToLoad(Error)
    }
}

// MARK: - State Machine
extension VenueDetailViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle(let id):
            switch event {
            case .onAppear:
                return .loading(id)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoad(let error):
                return .error(error)
            case .onLoaded(let location):
                return .loaded(location)
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
            guard case .loading(let id) = state else { return Empty().eraseToAnyPublisher() }
            let data = VenueDataHandler.getSingle(id: id)
            if let data = data {
                return Just(Event.onLoaded(data)).eraseToAnyPublisher()
            }
            let error = NSError(domain: "com.fouresquare.FourSquareDemo", code: 0, userInfo: ["location" : id])
            return  Just(Event.onFailedToLoad(error)).eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback(run: { _ in
            return input
        })
    }
}
