//
//  Binding+map.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 23.09.2024.
//

import SwiftUI
  
extension Binding {
    func map<NewValue>(
        get: @escaping (Value) -> NewValue,
        set: @escaping (NewValue) -> Value
    ) -> Binding<NewValue> {
        Binding<NewValue>(
            get: {
                get(wrappedValue)
            },
            set: { newValue in
                wrappedValue = set(newValue)
            }
        )
    }
}
