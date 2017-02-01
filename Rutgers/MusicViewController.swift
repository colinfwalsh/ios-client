//
//  MusicViewController.swift
//  Rutgers
//
//  Created by scm on 12/16/16.
//  Copyright © 2016 Rutgers. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MusicViewController: UIViewController , RUChannelProtocol, UIPopoverControllerDelegate
{

    static var audioPlayer : AVPlayer?
    var playing = false
    let channel : [NSObject : AnyObject]
    let playImageName = "ic_play_arrow_white_48pt"
    let pauseImageName = "ic_pause_white_48pt"
    var sharingPopoverController : UIPopoverController? = nil
    var shareButton : UIBarButtonItem? = nil
    let streamUrl : String

    @IBOutlet weak var volumeContainerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var wrnuLogo: UIImageView!
    @IBOutlet weak var backgroundView: UIView!

    static func channelHandle() -> String!
    {
        return "Radio";
    }
    /*
     Every class is register with the RUChannelManager by calling a register class static method in the load function of each class.
     The load is called in objc on every class by the run time library...
     The load handles the registration process .
     */
    static func registerClass()
    {
        RUChannelManager.sharedInstance().registerClass(MusicViewController.self)
    }
    
    static func channelWithConfiguration(channelConfiguration: [NSObject : AnyObject]!) -> AnyObject!
    {
        return MusicViewController(channel: channelConfiguration)
    }

    func setupPlayerIfNil() {
        if (MusicViewController.audioPlayer == nil || MusicViewController.audioPlayer?.error != nil) {
            MusicViewController.audioPlayer = AVPlayer(URL: NSURL(string: streamUrl)!)
        }
    }

    init(channel: [NSObject : AnyObject]) {
        self.channel = channel
        self.streamUrl = channel["url"] as! String
        super.init(nibName: .None, bundle: .None)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func actionButtonTapped() {
        if let url = sharingURL() {
            let favoriteActivity = RUFavoriteActivity(title: "WRNU")
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: [favoriteActivity])
            activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAddToReadingList]
            if (UI_USER_INTERFACE_IDIOM() == .Phone) {
                self.presentViewController(activityVC, animated: true, completion: nil)
                return
            }
            if let popover = self.sharingPopoverController {
                popover.dismissPopoverAnimated(false)
                self.sharingPopoverController = nil
            } else {
                self.sharingPopoverController = UIPopoverController(contentViewController: activityVC)
                self.sharingPopoverController?.delegate = self
                self.sharingPopoverController?.presentPopoverFromBarButtonItem(self.shareButton!, permittedArrowDirections: .Any, animated: true)
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupPlayerIfNil()
        self.shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(actionButtonTapped))
        self.navigationItem.rightBarButtonItem = self.shareButton
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "wrnu_background")!)
        backgroundView.opaque = false
        backgroundView.layer.opaque = false
        NSNotificationCenter
            .defaultCenter()
            .addObserver(
                self,
                selector: #selector(applicationWillEnterForeground),
                name: UIApplicationWillEnterForegroundNotification,
                object: nil
            )
    }

    func recreateIfStopped() {
        if (MusicViewController.audioPlayer?.rate == 0) {
            MusicViewController.audioPlayer = nil
        }
        setupPlayerIfNil()
    }

    func applicationWillEnterForeground() {
        recreateIfStopped()
        setupAudioSession()
        setPlayingState()
    }

    override func viewWillAppear(animated: Bool) {
        setPlayingState()
    }

    func sharingURL() -> NSURL? {
        return DynamicTableViewController.buildDynamicSharingURL(self.navigationController!, channel: self.channel)
    }

    func setPlayingState() {
        playing = MusicViewController.audioPlayer?.rate != 0 && MusicViewController.audioPlayer?.error == nil
        playButton?.setImage(UIImage(named: playing ? pauseImageName : playImageName), forState: .Normal)
    }

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        if #available(iOS 7.1, *) {
            let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
            commandCenter.playCommand.addTargetWithHandler({ event in
                self.toggleRadio()
                return .Success
            })
            commandCenter.pauseCommand.addTargetWithHandler({ event in
                self.toggleRadio()
                return .Success
            })
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        volumeContainerView.backgroundColor = UIColor.clearColor()
        let volumeView = MPVolumeView(frame: volumeContainerView.bounds)
        volumeContainerView.addSubview(volumeView)

        setupAudioSession()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toggleRadio() {
        setupPlayerIfNil()
        if (!playing) {
            MusicViewController.audioPlayer?.play()
            playButton.setImage(UIImage(named: pauseImageName), forState: .Normal)
            playing = true
        } else {
            MusicViewController.audioPlayer?.pause()
            playButton.setImage(UIImage(named: playImageName), forState: .Normal)
            playing = false
        }
    }

    @IBAction func playRadio(sender: UIButton) {
        toggleRadio()
    }
}
