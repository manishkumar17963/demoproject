//
//  store.swift
//  justchecking
//
//  Created by Manish Sah on 28/07/22.
//

import Foundation
import ReSwift


let appStore = Store<AppState> (reducer: appReducer, state: AppState())
