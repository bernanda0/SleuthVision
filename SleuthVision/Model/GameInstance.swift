//
//  GameInstance.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import Foundation

let gameTitle = "Case I"

let scenes = [
    Story(image: "sceneA.jpg", description: ""),
    Story(image: "sceneB.jpg", description: "")
]

let challenges = [
    Challenge(id: 0, location: caveRoom, items: caveRoomItems),
    Challenge(id: 1, location: pantry, items: pantryItems)
]

let caveRoom = Location(id: 0, name: "Cave Room")
let caveRoomItems = [
    Item(label: "person", hints: ["🧑🏻‍💻","🧍🏻","👓"], _class: "sleuthVisionLogo"),
    Item(label: "table", hints: ["🟨", "🙂"], _class: "smilyOnPostkit"),
]

let pantry = Location(id: 1, name: "Pantry")
let pantryItems = [
    Item(label: "cup", hints: ["⚙️", "☕️"], _class: "coffeeMachine"),
    Item(label: "spoon", hints: ["🥇"], _class: "goldenSpoon"),
    Item(label: "apple", hints: ["⌚️", "🟦"], _class: "appleWatchBlue")
]

let culprit = Culprit(image: "culprit.jpg", label: "The XX")

let game0 = Game(
    id: 0,
    title: gameTitle,
    story: scenes,
    challenges: challenges,
    culprit: culprit
)

let games = [game0]
