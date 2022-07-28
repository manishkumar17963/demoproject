//
//  appReducer.swift
//  justchecking
//
//  Created by Manish Sah on 28/07/22.
//

import ReSwift

func appReducer(action:Action, state:AppState?)-> AppState{
    var state = state ?? AppState()
    guard let action = action as? AppAction else{
        return state
    }
    
    switch action {
    case .setNumber(let number):
        state.number = number
    }
    return state
}
