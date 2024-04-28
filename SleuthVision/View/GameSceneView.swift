//
//  ContentView.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import SwiftUI

struct GameSceneView: View {
    @StateObject var gsvm = GameSceneVM(gameId: 0)
    
    var body: some View {
        NavigationStack { // Use NavigationStack
            List {
                ForEach(gsvm.selectedGame.challenges, id: \.location.id) { challenge in
                    NavigationLink(value: challenge) {
                        Text(challenge.location.name)
                    }
                }
            }
            .navigationDestination(for: Challenge.self) { challenge in
                ChallengeView(challenge: challenge.location.id)
            }
        }
    }
}

#Preview {
    GameSceneView()
}

