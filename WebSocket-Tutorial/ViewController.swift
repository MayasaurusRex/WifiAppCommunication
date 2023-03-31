//
//  ViewController.swift
//  WebSocket-Tutorial
//
//  Created by omair khan on 05/01/2022.
//

import UIKit

@available(iOS 13.0, *)
class ViewController: UIViewController,URLSessionWebSocketDelegate {

    @IBOutlet weak var TreadsLabel: UILabel!
    @IBOutlet weak var RunningLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var HumidityLabel: UILabel!
  
    var temp = "72.60"
    var hum = "22.16"

    private var webSocket1 : URLSessionWebSocketTask?
//    private var webSocket2 : URLSessionWebSocketTask?
//    let queue = DispatchQueue(label: "update")
    



    override func viewDidLoad() {
        super.viewDidLoad()

        //Session
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())

        //Server API
        let url1 = URL(string:  "ws://192.168.0.131:5778")
//        let url1 = URL(string:  "ws://192.168.0.131:5778")

        //Socket
        if #available(iOS 13.0, *) {
            webSocket1 = session.webSocketTask(with: url1!)
        } else {
            // Fallback on earlier versions
        }

        //Connect and hanles handshake
        webSocket1?.resume()
        
//        while(true) {
//            updateTemp(notification: temp)
//            updateHum(notification: hum)
//        }
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in self.background(timer: timer)
        }
        
    }
  
    

    @objc func updateTemp(notification: String?) -> Void{
        self.TemperatureLabel.text = notification
    }
    @objc func updateHum(notification: String?) -> Void{
        self.HumidityLabel.text = notification
    }
    
    func background (timer: Timer) {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            self.webSocket1?.receive(completionHandler: { result in
                
                switch result {
                case .success(let message):
                    
                    switch message {
                    
                    case .data(let data):
                        print("Data received \(data)")
                       
                        
                    case .string(let strMessgae):
                        print("String received \(strMessgae)")
                        if(strMessgae.count==11) {
                            let t = strMessgae.prefix(5)
                            self.temp = String(t)
//                                print(temp)

                            let h = strMessgae.suffix(5)
                            self.hum = String(h)
//                                print(hum)
//                                self?.HumidityLabel.text = hum + " %"
//                                self!.updateHum(notification: hum + " %")
                            
                        }
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print("Error Receiving \(error)")
                }
                // Creates the Recurrsion
                self.receive()
            })
            DispatchQueue.main.async {
                self.updateTemp(notification: self.temp)
                self.updateHum(notification: self.hum)
            }
        }
    }
    

    //MARK: Receive
    func receive(){
        /// This Recurring will keep us connected to the server
        /*
         - Create a workItem
         - Add it to the Queue
         */
       
        let workItem = DispatchWorkItem{ [weak self] in
            if #available(iOS 13.0, *) {
//                self?.webSocket1?.receive(completionHandler: { result in
//
//
//                    switch result {
//                    case .success(let message):
//
//                        switch message {
//
//                        case .data(let data):
//                            print("Data received \(data)")
//
//
//                        case .string(let strMessgae):
//                            print("String received \(strMessgae)")
//                            if(strMessgae.count==11) {
//                                let t = strMessgae.prefix(5)
//                                self?.temp = String(t)
////                                print(temp)
//
//                                let h = strMessgae.suffix(5)
//                                self?.hum = String(h)
////                                print(hum)
////                                self?.HumidityLabel.text = hum + " %"
////                                self!.updateHum(notification: hum + " %")
//
//                            }
//
//                        default:
//                            break
//                        }
//
//                    case .failure(let error):
//                        print("Error Receiving \(error)")
//                    }
//                    // Creates the Recurrsion
//                    self?.receive()
//                })
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
//        self.TemperatureLabel.text = temp + " °F"
//        self.HumidityLabel.text = hum + " %"
            }
        }
        
    }
    

    //MARK: Send
    func send(){
        /*
         - Create a workItem
         - Add it to the Queue
         */

        let workItem = DispatchWorkItem{

            if #available(iOS 13.0, *) {
                self.webSocket1?.send(URLSessionWebSocketTask.Message.string("Hello"), completionHandler: { error in
                    
                    
                    if error == nil {
                        // if error is nil we will continue to send messages else we will stop
//                        self.send()
                    }else{
                        print(error)
                    }
                })
            } else {
                // Fallback on earlier versions
            }
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
    }

    //MARK: Close Session
            func closeSession(){
                self.webSocket1?.cancel(with: .goingAway, reason: "You've Closed The Connection".data(using: .utf8))

    }


    //MARK: URLSESSION Protocols

    @available(iOS 13.0, *)
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        self.receive()
//        self.send()
    }


    @available(iOS 13.0, *)
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(reason)")
    }

}

//
//import UIKit
//import CoreBluetooth
//
//
//
//class RealUIViewController: UIViewController {
//
//    @IBOutlet weak var TreadsLabel: UILabel!
//    @IBOutlet weak var RunningLabel: UILabel!
//    @IBOutlet weak var TemperatureLabel: UILabel!
//    @IBOutlet weak var HumidityLabel: UILabel!
//
//    var peripheralManager: CBPeripheralManager?
//    var peripheral: CBPeripheral?
//    var periperalTXCharacteristic: CBCharacteristic?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLabels(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
//    @objc func updateLabels(notification: Notification) -> Void{
//        let recv = (notification.object! as! NSString)
//        if (recv.contains("T")) {
//            self.TemperatureLabel.text = "\(recv.substring(from: 1)) °F"
//        }
//        if (recv.contains("H")) {
//            self.HumidityLabel.text = "\(recv.substring(from: 1)) %"
//        }
//
//    }
//
//
//
//}
////import UIKit
////import CoreBluetooth
////
////
////
////@available(iOS 13.0, *)
////class ViewController: UIViewController, URLSessionDelegate {
////
////    @IBOutlet weak var TreadsLabel: UILabel!
////    @IBOutlet weak var RunningLabel: UILabel!
////    @IBOutlet weak var TemperatureLabel: UILabel!
////    @IBOutlet weak var HumidityLabel: UILabel!
////
////    var peripheralManager: CBPeripheralManager?
////    var peripheral: CBPeripheral?
////    var periperalTXCharacteristic: CBCharacteristic?
////
////    private var webSocket : URLSessionWebSocketTask?
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        //Session
////        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
////
////        //Server API
////        let url = URL(string:  "ws://localhost:5777")
////
////        //Socket
////        webSocket = session.webSocketTask(with: url!)
////
////        //Connect and hanles handshake
////        webSocket?.resume()
////
//////        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLabels(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
////    }
////
//////    override func viewDidLayoutSubviews() {
//////        super.viewDidLayoutSubviews()
//////    }
//////    @objc func updateLabels(notification: Notification) -> Void{
//////        let recv = (notification.object! as! NSString)
//////        if (recv.contains("T")) {
//////            self.TemperatureLabel.text = "\(recv.substring(from: 1)) °F"
//////        }
//////        if (recv.contains("H")) {
//////            self.HumidityLabel.text = "\(recv.substring(from: 1)) %"
//////        }
//////
//////    }
////    //MARK: Receive
////    func receive(){
////        /// This Recurring will keep us connected to the server
////        /*
////         - Create a workItem
////         - Add it to the Queue
////         */
////
////        let workItem = DispatchWorkItem{ [weak self] in
////
////            self?.webSocket?.receive(completionHandler: { result in
////
////
////                switch result {
////                case .success(let message):
////
////                    switch message {
////
////                    case .data(let data):
////                        print("Data received \(data)")
////
////                    case .string(let strMessgae):
////                    print("String received \(strMessgae)")
////
////                    default:
////                        break
////                    }
////
////                case .failure(let error):
////                    print("Error Receiving \(error)")
////                }
////                // Creates the Recurrsion
////                self?.receive()
////            })
////        }
////        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
////
////    }
////
////    //MARK: Send
////    func send(){
////        /*
////         - Create a workItem
////         - Add it to the Queue
////         */
////
////        let workItem = DispatchWorkItem{
////
////            self.webSocket?.send(URLSessionWebSocketTask.Message.string("Hello"), completionHandler: { error in
////
////
////                if error == nil {
////                    // if error is nil we will continue to send messages else we will stop
////                    self.send()
////                }else{
////                    print(error)
////                }
////            })
////        }
////
////        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
////    }
////
////    //MARK: Close Session
////    @objc func closeSession(){
////        webSocket?.cancel(with: .goingAway, reason: "You've Closed The Connection".data(using: .utf8))
////
////    }
////
////
////    //MARK: URLSESSION Protocols
////
////    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
////        print("Connected to server")
////        self.receive()
////        self.send()
////    }
////
////
////    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
////        print("Disconnect from Server \(reason)")
////    }
////
////
////
////}
