//
//  MenuButtonStateService.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 24.09.2024.
//

import Combine

final class MenuButtonStateService {
    @Published var startStopButtonKindPublisher: StartStopButtonStateKind = .configurationFileIsMissing
}
