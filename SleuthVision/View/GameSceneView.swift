//
//  ContentView.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import SwiftUI

struct GameSceneView: View {
    @StateObject var gsvm = GameSceneVM(gameId: 0)
    @State var isScanCulprit = false
    
    var body: some View {
        NavigationStack {
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
            
            NavigationLink(
                destination: CulpritScanView(),
                isActive: $isScanCulprit,
                label: {
                    Text("Scan Culpit")
                        .onTapGesture {
                            isScanCulprit = true
                        }// Use empty view as label
                })
        }
    }
}

#Preview {
    GameSceneView()
}

