//
//  ViewController.swift
//  ProgressBar
//
//  Created by MACBOOK PRO RETINA on 19/12/2018.
//  Copyright © 2018 MACBOOK PRO RETINA. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate {

   let shapelayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let urlString = "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"
    let percentLabel : UILabel = {
       let label = UILabel()
        label.text = "0%"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("DOWNLOAD", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.red
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func SetupView() {
        view.addSubview(percentLabel)
        percentLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentLabel.center = view.center
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = UIColor.red.cgColor
        shapelayer.lineCap = kCALineCapRound
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.lineWidth = 10
        shapelayer.strokeEnd = 0
        shapelayer.position = view.center
        shapelayer.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        view.layer.addSublayer(shapelayer)
        view.addSubview(downloadButton)
        downloadButton.frame = CGRect(x: 20, y: view.frame.height - 100, width: view.frame.width - 40, height: 50)
        downloadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        beginDownloadingFile()
    }
    
    func beginDownloadingFile() {
        shapelayer.strokeEnd = 0
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.percentLabel.text = "\(Int((CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)) * 100))%"
            self.shapelayer.strokeEnd = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "SUCCESS", message: "Download finished successfully", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }


}

