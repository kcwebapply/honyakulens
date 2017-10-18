//
//  SayClass.swift
//  honyakun
//
//  Created by WKC on 2016/09/14.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class SayClass:NSObject{
    
    var talker = AVSpeechSynthesizer()
    var lang:String!
    var langList:[String:String]! = ["en":"en-US","fr":"fr-FR","es":"es-MX","ko":"ko-KR","zh-CHS":"zh-CN","ru":"ru-RU","it":"it-IT","de":"de-DE"]
    
    init(lang:String){
        self.lang = lang
    }
    
    
    func Wsay(_ word:String){
        print("\(word):\(langList[lang])")
        let utterance = AVSpeechUtterance(string: word)
        //単語の選択
        utterance.voice = AVSpeechSynthesisVoice(language: langList[lang])
        // 実行
        utterance.rate = (0.3)//AVSpeechUtteranceMinimumSpeechRate
        utterance.pitchMultiplier = 1.5
        self.talker.speak(utterance)
    }

}
