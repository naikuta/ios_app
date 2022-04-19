import UIKit
import RealmSwift
import Foundation
 
class Player: Object {

    @objc dynamic var team: String = ""
    @objc dynamic var player: String = ""
    @objc dynamic var sh: Int = 0
    @objc dynamic var p: Int = 0
    @objc dynamic var a: Int = 0
    @objc dynamic var r: Int = 0
    @objc dynamic var s: Int = 0

}

class Team: Object {
    
    @objc dynamic var team: String = ""
    
    let playerList = List<Player>()
    
}

class Game: Object {

    @objc dynamic var gameTitle: String? = nil

    @objc dynamic var team: String = ""
    
}

