//
//  MySwiftData.swift
//  iNotice006.1_SwiftDataBase
//
//  Created by tarou yamasaki on 2015/02/04.
//  Copyright (c) 2015年 tarou yamasaki. All rights reserved.
//
/*
import Foundation

class MySwiftData {
    
    // テーブル作成
    init() {
        let (tb, err) = SD.existingTables()
        /**
        sample_table_001を変更して使う
        sample_table_001の部分をプロジェクト名_sample_table_001
        ：%s/置換前文字列/置換後文字列/gc
        */
        // sample_table_001が無ければ
      //  if !contains(tb, "sample_table_001") {
        if !tb.contains("sample_table_001") {

            
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("sample_table_001", withColumnNamesAndTypes: ["data":.stringVal, "data2":.stringVal]) {
                
            } else {
                // created successfully
            }
        }
        
        if !tb.contains("imageDBV") {
            
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("imageDBV", withColumnNamesAndTypes: ["name":.stringVal, "title":.stringVal,"text":.stringVal]) {
                
            } else {
                // created successfully
            }
        }
        
        if !tb.contains("wordTable") {
            
            
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("wordTable", withColumnNamesAndTypes: ["word":.stringVal, "text":.stringVal,"lang":.stringVal]) {
                
            } else {
                // created successfully
            }
        }

        if !tb.contains("imageTextDB") {
                       // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("imageTextDB", withColumnNamesAndTypes: ["name":.stringVal, "title":.stringVal,"text":.stringVal,"lang":.stringVal]) {
                
            } else {
                               // created successfully
            }
        }
        
        
        if !tb.contains("orgTextDB") {
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("orgTextDB", withColumnNamesAndTypes: ["name":.stringVal, "title":.stringVal,"text":.stringVal,"lang":.stringVal]) {
                
            } else {
                // created successfully
            }
        }
        


        
        if !tb.contains("textDBV") {
            
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("textDBV", withColumnNamesAndTypes: ["text":.stringVal, "trans":.stringVal]) {
                
            } else {
                // created successfully
            }
        }
        
        if !tb.contains("ExCheck") {
            
            
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("ExCheck", withColumnNamesAndTypes: ["QN":.intVal,"condition":.intVal]) {
                
            } else {
                SD.executeChange("INSERT INTO ExCheck (QN,condition) VALUES (5,1)")
                // created successfully
            }
        }
        
        if !tb.contains("IdCheck") {
            
            
            // sample_table_001を作成,その際"id"は自動生成 dataはStringVal = string型
            if let err = SD.createTable("IdCheck", withColumnNamesAndTypes: ["QN":.intVal,"condition":.intVal]) {
                
            } else {
                  SD.executeChange("INSERT INTO IdCheck (QN,condition) VALUES (5,1)")
                // created successfully
            }
        }



        
              // databaseのパスを表示
       // println(SD.databasePath())
    }
    
    /**
    INSERT文（追加）
    var add = 自作databaseクラス.add("3urprise") これでdatabaseに"3urprise"と追加される
    */
    func add(_ str:String,str2:String) -> String {
        
        var result:String? = nil
        if let err = SD.executeChange("INSERT INTO sample_table_001 (data,data2) VALUES (?,?)", withArgs: [str,str2]) {
            // there was an error during the insert, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                // err
            }else{
                // ok
                result = String(id)
            }
        }
        return result!
    }
    
    func Cadd(_ str:String,str2:String) -> String {
       /* let pattern = "[\\<\\/br\\>|\\\n|[^a-z]]";
        let replace=""
        let replacedStr = str.stringByReplacingOccurrencesOfString(pattern, withString:replace, options:NSStringCompareOptions.RegularExpressionSearch, range:nil)*/
        let replacedStr = str
        var result:String? = nil
        var flag = true
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001 where data='\(replacedStr)'")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    flag = false
                }
            }
        }
        
        if flag==true{
            if let err = SD.executeChange("INSERT INTO sample_table_001 (data,data2) VALUES (?,?)", withArgs: [replacedStr,str2]) {
            // there was an error during the insert, handle it here
            } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
                let (id, err) = SD.lastInsertedRowID()
                if err != nil {
                // err
                }else{
                // ok
                    result = String(id)
                }
            }
            return result!
        }else{
 
            return "NO"
        }
    }
    
    func wordAdd(_ str:String,str2:String,lang:String) -> String {
        let replacedStr = str
        var result:String? = nil
        var flag = true
        let (resultSet, err) = SD.executeQuery("SELECT * FROM wordTable where word='\(replacedStr)'")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    flag = false
                }
            }
        }
        
        if flag==true{
            if let err = SD.executeChange("INSERT INTO wordTable (word,text,lang) VALUES (?,?,?)", withArgs: [replacedStr,str2,lang]) {
                // there was an error during the insert, handle it here
            } else {
                let (id, err) = SD.lastInsertedRowID()
                if err != nil {
                    // err
                }else{
                    // ok
                    result = String(id)
                }
            }
            return result!
        }else{
            
            return "NO"
        }
    }

    
    
    func AnsGet(_ str:String) -> String {
        /* let pattern = "[\\<\\/br\\>|\\\n|[^a-z]]";
        let replace=""
        let replacedStr = str.stringByReplacingOccurrencesOfString(pattern, withString:replace, options:NSStringCompareOptions.RegularExpressionSearch, range:nil)*/
        let replacedStr = str
        var result:String? = ""
        var flag = true
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001 where data='\(replacedStr)'")
        if err != nil {
            return ""
        } else {
                for row in resultSet {
                    if let id = row["ID"]!.asInt() {
                        result=row["data2"]!.asString()
                        
                    }
                }
        }
        return result!
        
    }
    
    func Tadd(_ str:String,str2:String) -> String {
        /* let pattern = "[\\<\\/br\\>|\\\n|[^a-z]]";
        let replace=""
        let replacedStr = str.stringByReplacingOccurrencesOfString(pattern, withString:replace, options:NSStringCompareOptions.RegularExpressionSearch, range:nil)*/
        let replacedStr = str
        var result:String? = nil
        var flag = true
        let (resultSet, err) = SD.executeQuery("SELECT * FROM textDBV where data='\(replacedStr)'")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    flag = false
                }
            }
        }
        
        if flag==true{
            if let err = SD.executeChange("INSERT INTO textDBV (text,trans) VALUES (?,?)", withArgs: [replacedStr,str2]) {
                // there was an error during the insert, handle it here
            } else {
                // no error, the row was inserted successfully
                // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
                let (id, err) = SD.lastInsertedRowID()
                if err != nil {
                    // err
                }else{
                    // ok
                    result = String(id)
                }
            }
            return result!
        }else{
            
            return "NO"
        }
    }
    
    func AnsTGet(_ str:Int) -> String {
        /* let pattern = "[\\<\\/br\\>|\\\n|[^a-z]]";
        let replace=""
        let replacedStr = str.stringByReplacingOccurrencesOfString(pattern, withString:replace, options:NSStringCompareOptions.RegularExpressionSearch, range:nil)*/
        let replacedStr = str
       // print(replacedStr)
        var result:String? = ""
        var flag = true
        let (resultSet, err) = SD.executeQuery("SELECT * FROM textDBV where id='\(replacedStr)'")
        if err != nil {
            return ""
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    result=row["trans"]!.asString()
                   // print("翻訳\(result)")
                    
                }
            }
        }
        return result!
        
    }
    
    func getAllText()->Dictionary<Int,Dictionary<String,String>>{
        var result:Dictionary=[Int:[String:String]]()
        var index:Int=0
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM textDBV ")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    let dataStr = row["text"]!.asString()!
                    result[index] = ["ID":String(id),"text":dataStr]
                   // result[id] = dataStr
                    index+=1
                }
            }
        }
        //print(result)
        return result
        
    }



    
    func addImage(_ name:String,title:String,text:String) -> String {
        let nameV:String! = SD.escapeValue(name)
        let titleV:String! = SD.escapeValue(title)
        let textV:String! = SD.escapeValue(text)
       // print("パス：\(nameV),\nタイトル：\(titleV)\n\n")
        
        var result:String? = nil
        let query = "INSERT INTO imageDBV (name,title,text) VALUES (\(nameV),\(titleV),\(textV))"
       //print(query)
        //if let err = SD.executeChange("INSERT INTO imageDB (name,text) VALUES (?,?)", withArgs: [nameV,textV]) 
            if let err = SD.executeChange(query){
            print("エラー")
            // there was an error during the insert, handle it here
        } else {
            // no error, the row was inserted successfully
            // lastInsertedRowID = 直近の INSERT 文でデータベースに追加された行の ID を返す
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                print(err)
            }else{
                // ok
                result = String(id)
            }
        }
       // print(result)
        return result!
    }
    
    
    func addText(_ name:String,title:String,text:String,lang:String) -> String {
        let nameV:String! = SD.escapeValue(name)
        let titleV:String! = SD.escapeValue(title)
        let textV:String! = SD.escapeValue(text)
        let langV:String! = SD.escapeValue(lang)
        var result:String? = nil
        let query = "INSERT INTO imageTextDB (name,title,text,lang) VALUES (\(nameV),\(titleV),\(textV),\(langV))"

        if let err = SD.executeChange(query){
            print("エラー")
            // there was an error during the insert, handle it here
        } else {
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                print(err)
            }else{
                // ok
                result = String(id)
            }
        }
        // print(result)
        return result!
    }
    
    func addOrgText(_ name:String,title:String,text:String,lang:String) -> String {
        let nameV:String! = SD.escapeValue(name)
        let titleV:String! = SD.escapeValue(title)
        let textV:String! = SD.escapeValue(text)
        let langV:String! = SD.escapeValue(lang)
        var result:String? = nil
        let query = "INSERT INTO orgTextDB (name,title,text,lang) VALUES (\(nameV),\(titleV),\(textV),\(langV))"
        
        if let err = SD.executeChange(query){
            print("エラー")
            // there was an error during the insert, handle it here
        } else {
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                print(err)
            }else{
                // ok
                result = String(id)
            }
        }
        // print(result)
        return result!
    }


    func getTitle(_ name:String)->String{
        let ary:NSArray = name.components(separatedBy: "/")
        let name = ary[ary.count-1]
        let nameV = SD.escapeValue(name)
       
        //var result = Dictionary<String,AnyObject>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let query = "SELECT * FROM imageTextDB where name=\(nameV)"
        //print(query)
        let (resultSet, err) = SD.executeQuery(query)
        if err != nil {
            // nil
            
        } else {
            
            var i=0
            
            for row in resultSet {
                i = i + 1
                
                if let id = row["ID"]!.asInt() {
                 //    print("画像名\(nameV)")
                   // print(row["title"])
                    //return ""
                    let textStr = row["title"]!.asString()!
                    // let dataStr2 = row["data2"]!.asString()!
                    //return ""
                    return textStr
                    
                }
            }
        }
        //print(result)
        return ""
    }
    
    func getLang(_ name:String)->String{
        let ary:NSArray = name.components(separatedBy: "/")
        let name = ary[ary.count-1]
        let nameV = SD.escapeValue(name)
        
        //var result = Dictionary<String,AnyObject>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let query = "SELECT * FROM imageTextDB where name=\(nameV)"
        //print(query)
        let (resultSet, err) = SD.executeQuery(query)
        if err != nil {
            // nil
            
        } else {
            
            var i=0
            
            for row in resultSet {
                i = i + 1
                
                if let id = row["ID"]!.asInt() {
                    //    print("画像名\(nameV)")
                    // print(row["title"])
                    //return ""
                    let textStr = row["lang"]!.asString()!
                    // let dataStr2 = row["data2"]!.asString()!
                    //return ""
                    return textStr
                    
                }
            }
        }
        //print(result)
        return ""
    }


    
    func getImage(_ name:String)->String{
        let ary:NSArray = name.components(separatedBy: "/")
        let name = ary[ary.count-1]
        let nameV = SD.escapeValue(name)

        //var result = Dictionary<String,AnyObject>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let query = "SELECT * FROM imageTextDB where name=\(nameV)"
       // print(query)
        let (resultSet, err) = SD.executeQuery(query)
        if err != nil {
            // nil

        } else {

            var i=0

            for row in resultSet {
                i = i + 1

                if let id = row["ID"]!.asInt() {
                    let textStr = row["text"]!.asString()!
                    // let dataStr2 = row["data2"]!.asString()!
                    var title = row["title"]!
                  //  print("\(title)")
                    return textStr
                    
                }
            }
        }
        //print(result)
        return ""
    }
    
    func getOrgText(_ name:String)->String{
        let ary:NSArray = name.components(separatedBy: "/")
        let name = ary[ary.count-1]
        let nameV = SD.escapeValue(name)
        
        //var result = Dictionary<String,AnyObject>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let query = "SELECT * FROM orgTextDB where name=\(nameV)"
        // print(query)
        let (resultSet, err) = SD.executeQuery(query)
        if err != nil {
            // nil
            
        } else {
            
            var i=0
            
            for row in resultSet {
                i = i + 1
                
                if let id = row["ID"]!.asInt() {
                    let textStr = row["text"]!.asString()!
                    // let dataStr2 = row["data2"]!.asString()!
                    var title = row["title"]!
                    print("文章=>\(textStr)--------")
                    return textStr
                    
                }
            }
        }
        //print(result)
        return ""
    }

    
    
    
    func getAllImage() -> NSMutableArray {
        let result = NSMutableArray()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM imageDBV")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let dataStr = row["name"]!.asString()!
                    let dataStr2 = row["text"]!.asString()!
                    // println("\(dataStr),\n\(dataStr2)\n\n")
                }
            }
        }
        return result
    }



    /**
    DELETE文
    var del = 自作databaseクラス.delete(Int) これでテーブルのID削除
    */
    func delete(_ id:Int) -> Bool {
        if let err = SD.executeChange("DELETE FROM sample_table_001 WHERE ID = ?", withArgs: [id]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }
    
    func deleteT(_ id:Int) -> Bool {
        if let err = SD.executeChange("DELETE FROM textDBV WHERE ID = ?", withArgs: [id]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }

    
    func deleteword(_ str:String) -> Bool {
        if let err = SD.executeChange("DELETE FROM wordTable WHERE word = '\(str)'") {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }

    
    /**
    SELECT文
    var selects = 自作databaseクラス.getAll() これでNSMutableArray型の内容が取得出来る
    */
    
    
    func getWord(_ num:Int)->Dictionary<String,AnyObject>{
        var result = Dictionary<String,AnyObject>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM wordTable where ID=\(num)")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    let word = row["word"]!.asString()
                    let text = row["text"]!.asString()
                    let dic:[String:AnyObject] = ["ID":id, "word":word!,"text":text!]
                    result=dic 
                }
            }
        }
        //print(result)
        return result
        
    }
    
    func getRandomWord()->Dictionary<Int,String>{
        var result = Dictionary<Int,String>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        var i = 0
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001 ORDER BY RANDOM() LIMIT 5")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    result[i] = row["data"]!.asString()!
                    //print(row["data"]!.asString()!)
                    i+=1
                    
                }
            }
        }
        //print(result)
        return result

        
    }
    
    func getRandomWordOne(_ nowAry:[Int:String])->String{
        var result = Dictionary<Int,String>()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        var i = 0
        let nA = nowAry.values
        let arysum = nA.joined(separator: ",")
        //var u = ",".join(nowAry)
     //   print(arysum)
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001 where data not in (\(arysum)) ORDER BY RANDOM() LIMIT 1 ")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
        
                    return row["data"]!.asString()!
         
                    
                }
            }
        }
        //print(result)
        return ""

        
        
    }
    
    func getNum(_ table:String)->Int{
        var result:Int=0
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM \(table)")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    /*let dataStr = row["data"]!.asString()!
                    let dataStr2 = row["data2"]!.asString()!
                    
                    let dic = ["ID":id, "data":dataStr, "data2":dataStr2]
                    result=dic as! Dictionary<String, AnyObject>*/
                    result += 1
                }
            }
        }
        //print(result)
        return result
        
    }
    
    func getAll() -> NSMutableArray {
        let result = NSMutableArray()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let dataStr = row["data"]?.asString()!
                    let dataStr2 = row["data2"]?.asString()!
                    
                    let dic = ["ID":id, "data":dataStr!, "data2":dataStr2!]
                    result.add(dic)
                }
            }
        }
        return result
    }
    
    func getWords() -> NSMutableArray {
        let result = NSMutableArray()
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM wordTable")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let dataStr = row["word"]?.asString()!
                    let dataStr2 = row["text"]?.asString()!
                    let dataStr3 = row["lang"]?.asString()!
                    
                    let dic = ["ID":id, "word":dataStr!, "text":dataStr2!,"lang":dataStr3!]
                    result.add(dic)
                }
            }
        }
        return result
    }
    
    
    func getAllWords()->Dictionary<Int,Dictionary<String,String>>{
        var result:Dictionary=[Int:[String:String]]()
        var index:Int=0
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM wordTable ORDER BY text desc ")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    let word = row["word"]!.asString()!
                    let lang = row["lang"]!.asString()!
                    result[index] = ["ID":String(id),"word":word,"lang":lang]
                    index+=1
                }
            }
        }
        //print(result)
        return result
        
    }

    
    
    
    func getAllWord()->Dictionary<Int,Dictionary<String,String>>{
        var result:Dictionary=[Int:[String:String]]()
        var index:Int=0
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001 ORDER BY data2 desc ")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    let dataStr = row["data"]!.asString()!
                    result[index] = ["ID":String(id),"data":dataStr]
                    index+=1
                }
            }
        }
        //print(result)
        return result
        
    }
    
    func check(){
        let (resultSet, err) = SD.executeQuery("SELECT * FROM imageDBV")
        if err != nil{
            print("エラーじゃな")
        }else{
            for row in resultSet{
                if let id = row["ID"]!.asInt(){
//                    print(row)

                    
                }
            }
        }

    }
    
    func getRepreText()->String{
        var result:String = ""
        var index:Int=0
        // 新しい番号から取得する場合は "SELECT * FROM sample_table_001 ORDER BY ID DESC" を使う
        let (resultSet, err) = SD.executeQuery("SELECT * FROM sample_table_001 ORDER BY data2 desc LIMIT 100")
        if err != nil {
            // nil
        } else {
            for row in resultSet {
                if let id = row["ID"]!.asInt() {
                    let dataStr = row["data"]!.asString()!
                    result += " "
                    result += dataStr
                        // ["ID":String(id),"data":dataStr]
                    index+=1
                }
            }
        }
        //print(result)
        return result
        
    }
    
    func getExCondition() -> Int {
        
        let (resultSet, err) = SD.executeQuery("SELECT * FROM ExCheck where QN = 5")
        var result = 0;
        if err != nil {
            return -100
        } else {
                 print("くりあ")
            for row in resultSet {
                print("れつはあるな")
                if let id = row["QN"]!.asInt() {
                    result=row["condition"]!.asInt()!
                      print("ちゃんと取得したよ=>\(result)")
                    // print("翻訳\(result)")
                    
                }
            }
        }
        return result
        
    }
    
    func getIdCondition() -> Int {
        
        let (resultSet, err) = SD.executeQuery("SELECT * FROM IdCheck where QN = 5")
        var result = 0;
        if err != nil {
            return -100
        } else {
            print("くりあ")
            for row in resultSet {
                print("れつはあるな")

                if let id = row["QN"]!.asInt() {
                    result=row["condition"]!.asInt()!
                    print("ちゃんと取得したよ=>\(result)")
                    // print("翻訳\(result)")
                    
                }
            }
        }
        return result
        
    }
    
    func setExCondition(_ value:Int){
        let (resultSet, err) = SD.executeQuery("update ExCheck set condition=\(value) where QN = 5")
         if err != nil{
           // print("変更失敗")
        }else{
            
           // print("変更しました")
        }
    }
    
    func setIdCondition(_ value:Int){
        let (resultSet, err) = SD.executeQuery("update IdCheck set condition=\(value) where QN = 5")
        if err != nil{
           // print("変更失敗")
        }else{
           // print("変更しました")
        }
    }
    
    

    
    

    


}
*/



