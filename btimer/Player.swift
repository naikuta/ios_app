import UIKit
import RealmSwift
import Foundation
 
class Player: Object {

    @objc dynamic var playerId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sh: Int = 0
    @objc dynamic var p: Int = 0
    @objc dynamic var a: Int = 0
    @objc dynamic var r: Int = 0
    @objc dynamic var s: Int = 0

    override static func primaryKey() -> String? {
        return "playerId"
    }
}

class PlayerModel {
    static let dao = RealmBaseDao<Player>()
}

class Team: Object {
    
    @objc dynamic var teamId: String = ""
    @objc dynamic var teamName: String = ""
    
    let playerList = List<Player>()
    
    override static func primaryKey() -> String? {
        return "teamId"
    }
}

class TeamModel {
    static let dao = RealmBaseDao<Team>()
}

class Game: Object {
    // ゲームID
    @objc  dynamic var gameId: String? = nil
    // ゲームタイトル
    @objc dynamic var gameTitle: String? = nil

    let teamList = List<Team>()
    // Primary Keyの設定
    override static func primaryKey() -> String? {
        return "gameId"
    }
}

class GameModel {
    static let dao = RealmBaseDao<Game>()
}
