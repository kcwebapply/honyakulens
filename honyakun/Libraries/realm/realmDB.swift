//
//  realmDB.swift
//  honyakun
//
//  Created by WKC on 2017/01/15.
//  Copyright © 2017年 WKC. All rights reserved.
//

import Foundation
import RealmSwift

class wordDB:Object{
    static let realm = try! Realm()
    dynamic var id = 0
    dynamic var word = ""
    dynamic var mean = ""
    dynamic var lang = ""
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    func saveWord(wordw:String,mean:String,lang:String){
        let word = wordDB()
        word.id = getLastId()
        word.id = word.id+1
        word.word = wordw
        word.mean = mean
        word.lang = lang
        try! wordDB.realm.write {
            wordDB.realm.add(word)
        }
    }
    
    func getAllWord()->Dictionary<Int,wordDB>{
        let allWords = wordDB.realm.objects(wordDB)
        var ret: [Int:wordDB] = [:]
        
        for ind in 0..<allWords.count{
            ret[ind] = allWords[ind]
        }
        
        return ret
    }
    
    
    private func getLastId()->Int{
        let lasId:Int!
        if(getAllWord().count != 0){
            lasId = wordDB.realm.objects(wordDB.self).sorted(byProperty: "id", ascending: true).last?.id
        }else{
            lasId = 0
        }
        return lasId!
    }
    
   /* func deleteWord(ind:Int){
        let wordObj = wordDB.realm.objects(wordDB).filter("id==%@",ind)
        try! wordDB.realm.write {
            wordDB.realm.delete(wordObj)
        }
    }*/
    
    func deleteWord(wordw:String){
        let wordObj = wordDB.realm.objects(wordDB).filter("word==%@",wordw)
        try! wordDB.realm.write {
            wordDB.realm.delete(wordObj)
        }
    }

    
    func getAnsWord(wordw:String)->String{
        let res = wordDB.realm.objects(wordDB).filter("word==%@",wordw).first
        return (res?.mean)!
        
    }
    
    /*func getWord(id:Int)->Dictionary<String,anyObject>{
        let les = wordDB.realm.objects(wordDB).filter("id==%@",id).first
        return les;
    }*/


}

class textDB:Object {
    dynamic var id = 0
    dynamic var text = ""
    dynamic var trans = ""
    
    static let realm = try! Realm()
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    func getLastId()->Int{
        var lasId:Int!
        if(getAllText().count != 0){
            lasId = textDB.realm.objects(textDB).sorted(byProperty: "id", ascending: true).last?.id
        }else{
            lasId = 0
        }
        return lasId!
    }
    func getAllText()->Dictionary<Int,textDB>{
        var result:Dictionary = [Int:textDB]()
        var textDatas = textDB.realm.objects(textDB)
        for ind in 0..<textDatas.count{
            result[ind] = textDatas[ind]
        }
        return result
    }
    
    func getAnsText(_ ind:Int)->String{
        guard let  ansText = textDB.realm.objects(textDB).filter("id==%@",ind).first else{
            return ""
        }
        return ansText.trans
    }
    
    func textAdd(_ engText:String,transText:String){
        let textIns = textDB()
        textIns.id = getLastId()
        textIns.id = textIns.id+1
        textIns.text = engText
        textIns.trans = transText
        try! textDB.realm.write {
            textDB.realm.add(textIns)
        }
    }
    
    func deleteText(ind:Int){
        let textObj = textDB.realm.objects(textDB).filter("id==%@",ind).first
        try! textDB.realm.write {
            textDB.realm.delete(textObj!)
        }
    }
    
}

class imageDB:Object{
    dynamic var id = 0
    dynamic var name = ""
    dynamic var title = ""
    dynamic var text = ""
    dynamic var lang = ""
    
    static let realm = try! Realm()
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    
    func getTitle(name:String)->String{
        guard let data = imageDB.realm.objects(imageDB).filter("name==%@",name).first else {
            return ""
        }
        return data.title
    }
    
    func getImage(name:String)->String{
        //エスケープ処理がおそらく必要
        guard let textI = imageDB.realm.objects(imageDB).filter("name==%@",name).first?.text else {
            return ""
        }
        return textI
        
    }
    
    func getLang(name:String)->String{
        guard let tlang = imageDB.realm.objects(imageDB).filter("name==%@",name).first?.lang else {
            return ""
        }
        return tlang

    }
    
    func getAllImage()->Dictionary<Int,imageDB>{
        let results = imageDB.realm.objects(imageDB)
        var resAry = [Int:imageDB]()
        for u in 0..<results.count{
            resAry[u] = results[u]
        }
        return resAry
    }
    
    func addImage(name:String,title:String,text:String,lang:String){
        //各値エスケープすること
        var imageObj = imageDB()
        imageObj.name = name
        imageObj.text = text
        imageObj.title = title
        imageObj.lang = lang
        imageObj.id = getLastId()
        try! imageDB.realm.write {
            imageDB.realm.add(imageObj)
            print("保存完了=>\(name),\(title),\(lang)")
        }
    }
    
    func getLastId()->Int{
        var lasId:Int!
        if(getAllImage().count != 0){
            lasId = imageDB.realm.objects(imageDB).sorted(byProperty: "id", ascending: true).last?.id
        }else{
            lasId = 0
        }
        return lasId!+1
    }
    
    func deleteImage(name:String!){
        let imageObj = imageDB.realm.objects(imageDB).filter("name==%@",name).first
        try! imageDB.realm.write {
            imageDB.realm.delete(imageObj!)
        }
    }
    
}

class orgTextDB:Object{
    dynamic var id = 0
    dynamic var name = ""
    dynamic var title = ""
    dynamic var text = ""
    dynamic var lang = ""
    
    static let realm = try! Realm()
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    
    func getTitle(name:String)->String{
        guard let data = orgTextDB.realm.objects(orgTextDB).filter("name==%@",name).first else {
            return ""
        }
        return data.title
    }
    
    func getImage(name:String)->String{
        //エスケープ処理がおそらく必要
        guard let textI = orgTextDB.realm.objects(orgTextDB).filter("name==%@",name).first?.text else {
            return ""
        }
        return textI
        
    }
    
    func getAllImage()->Dictionary<Int,orgTextDB>{
        let results = orgTextDB.realm.objects(orgTextDB)
        var resAry = [Int:orgTextDB]()
        for u in 0..<results.count{
            resAry[u] = results[u]
        }
        return resAry
    }
    
    func addImage(name:String,title:String,text:String,lang:String){
        //各値エスケープすること
        var imageObj = orgTextDB()
        imageObj.name = name
        imageObj.text = text
        imageObj.title = title
        imageObj.lang = lang
        imageObj.id = getLastId()
        try! orgTextDB.realm.write {
            orgTextDB.realm.add(imageObj)
        }
    }
    
    func getLastId()->Int{
        var lasId:Int!
        if(getAllImage().count != 0){
            lasId = orgTextDB.realm.objects(orgTextDB).sorted(byProperty: "id", ascending: true).last?.id
        }else{
            lasId = 0
        }
        return lasId!+1
    }
    
    func deleteImage(name:String!){
        let imageObj = orgTextDB.realm.objects(orgTextDB).filter("name==%@",name).first
        try! orgTextDB.realm.write {
            orgTextDB.realm.delete(imageObj!)
        }
    }
    
    
    
}




class ExCheckDB:Object {
    dynamic var id = 0
    dynamic var QN = 5
    dynamic var condition = 1
    static let realm = try! Realm()
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    func initExCondition(){
        var obj = ExCheckDB()
        obj.id = 0
        obj.QN = 5
        obj.condition = 1
        try! ExCheckDB.realm.write{
            if(ExCheckDB.realm.objects(ExCheckDB).count==0){
                ExCheckDB.realm.add(obj)
            }
        }
    }
    
    func getExCondition()->Int{
        let res = ExCheckDB.realm.objects(ExCheckDB).first
        return (res?.condition)!
    }
    
    func setExCondition(condition:Int){
        var obj = ExCheckDB()
        obj.id = 0
        obj.condition = condition
        obj.QN = 5
        try! ExCheckDB.realm.write {
            ExCheckDB.realm.add(obj,update:true)
        }
        
    }
}


class IDCheckDB:Object {
    static let realm = try! Realm()
    dynamic var id = ""
    dynamic var QN = ""
    dynamic var condition = ""
    
    override class func primaryKey() -> String{
        return "id"
    }
    func initIDCondition(){
        var obj = ExCheckDB()
        obj.id = 0
        obj.QN = 5
        obj.condition = 1
        try! IDCheckDB.realm.write{
            IDCheckDB.realm.add(obj)
        }
    }
    
    func getIdCondition()->Int{
        let res = IDCheckDB.realm.objects(ExCheckDB).first
        return (res?.condition)!
    }
    
    func setIdCondition(condition:Int){
        var obj = ExCheckDB()
        obj.id = 0
        obj.condition = condition
        obj.QN = 5
        try! IDCheckDB.realm.write {
            IDCheckDB.realm.add(obj,update:true)
        }
        
    }
    
}
