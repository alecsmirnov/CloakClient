//
//  UserDefaultsHelper.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Foundation

private enum Constants {
    static let clockClientParametersKey = "ck-client-parameters"
}

enum UserDefaultsHelper {
    static func getLaunchParameters() -> String? {
        UserDefaults.standard.string(forKey: Constants.clockClientParametersKey)
    }

    static func set(launchParameters: String) {
        UserDefaults.standard.set(launchParameters, forKey: Constants.clockClientParametersKey)
    }

    static func clearLaunchParameters() {
        UserDefaults.standard.removeObject(forKey: Constants.clockClientParametersKey)
    }
}
