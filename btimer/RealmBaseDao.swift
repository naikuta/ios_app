//
//  RealmBaseDao.swift
//  TimerAndStats
//
//  Created by iku on 2022/04/28.
//

import Foundation
import RealmSwift

class RealmBaseDao <T : RealmSwift.Object> {
    let realm: Realm

    init() {
        try! realm = Realm()
    }

    /**
     * 新規主キー発行
     */
    func newId() -> String? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        let r = realm
        if let last = realm.objects(T.self).last as? RealmSwift.Object,
            let lastId = last[key] as? String {
            let count = lastId.count
            let classNameCount = T.className().count
            let no = lastId.suffix(count - classNameCount)
            let suffix = Int(no)! + 1
            return T.className() + String(suffix)
        } else {
            return T.self.className() + String(1)
        }
    }

    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }

    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }

    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }

    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }

    /**
     * レコード追加を取得
     */
    func add(d :T) {
        do {
            try realm.write {
                realm.add(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

    /**
    * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
    */
    func update(d: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(d, update: .modified)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }

    /**
     * レコード削除
     */
    func delete(d: T) {
        do {
            try realm.write {
                realm.delete(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

    /**
     * レコード全削除
     */
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

}
