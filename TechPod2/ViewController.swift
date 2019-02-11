//
//  ViewController.swift
//  TechPod2
//
//  Created by Yasuko Namikawa on 2019/02/09.
//  Copyright © 2019年 Yasuko Namikawa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet var table: UITableView!
    @IBOutlet var playButton: UIButton!
    
    var fileName = [String]()
    var audioPlayer: AVAudioPlayer!
    var number: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //音楽のファイル名を取得してfileName配列に入れる
        let fileManager: FileManager = FileManager.default
        do{
            fileName = try fileManager.contentsOfDirectory(atPath: "/Users/yasukonamikawa/Documents/swift/TechPod2/TechPod2/ClassicalMusic")
//            fileName = try fileManager.contentsOfDirectory(atPath: Bundle.main.path(forResource: "ClassicalMusic", ofType: "m4a")!)
            fileName.remove(at: fileName.index(of: ".DS_Store")!)
            print(fileName)
            
        }catch{
            print("error")
        }
        
        table.dataSource = self
        table.delegate = self
        setPaly()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        //セルに曲名を表示する
        cell?.textLabel?.text = fileName[indexPath.row]
        
        return cell!
    }
    
    //audioPlayerで再生する音楽の指定
    func setPaly() {
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forAuxiliaryExecutable: fileName[number])!)
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        audioPlayer.delegate = self
    }
    
    //セルが押されたときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        number = indexPath.row
        setPaly()
        audioPlayer.play()
        buttonImageChange()

    }
    
    //buttonの画像を変えるメソッド
    func buttonImageChange() {
        if audioPlayer.isPlaying {
            let buttonImage = UIImage(named: "pause.png")
            playButton.setBackgroundImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "play.png")
            playButton.setBackgroundImage(buttonImage, for: .normal)
        }
    }
    
    // 再生・停止ボタン
    @IBAction func PlayPause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            buttonImageChange()
        } else {
            audioPlayer.play()
            buttonImageChange()
        }
    }

    // 再生終了時の呼び出しメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("aaa")
        if number < (fileName.count - 1) {
            number += 1
            setPaly()
            audioPlayer.play()
            buttonImageChange()
        }else{
            number = 0
            let buttonImage = UIImage(named: "play.png")
            playButton.setBackgroundImage(buttonImage, for: .normal)
        }
    }
    
    //nextButton
    @IBAction func next() {
        if number < (fileName.count - 1) {
            number += 1
            setPaly()
            audioPlayer.play()
            buttonImageChange()
        }else{
            number = 0
            let buttonImage = UIImage(named: "play.png")
            playButton.setBackgroundImage(buttonImage, for: .normal)
        }
    }
    
    //backButton
    @IBAction func back() {
        if audioPlayer.currentTime < 3.0 {
            if number > 0 {
                number -= 1
                setPaly()
                audioPlayer.play()
                buttonImageChange()
            }else{
                number = 0
                let buttonImage = UIImage(named: "play.png")
                playButton.setBackgroundImage(buttonImage, for: .normal)
            }
        }else{
            setPaly()
            audioPlayer.play()
        }
        
    }

}

