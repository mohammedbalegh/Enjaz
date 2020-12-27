import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case let action as SetIsConnectedToInternetAction:
        state.isConnectedToInternet = action.isConnectedToInternet
    default:
        break
    }
    
    return state
}
