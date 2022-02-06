//
//  VideoVC.swift
//  Movies
//
//  Created by Sulfah on 19/01/2022.
//

import UIKit
import YouTubeiOSPlayerHelper
class VideoVC: UIViewController {

    @IBOutlet weak var videoView: YTPlayerView!
    var vidID:String!
    var indicator:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        videoView.load(withVideoId: vidID)
        videoView.delegate = self
    }
    
    private func setupIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .cornGreen
        view.addSubview(indicator)
        indicator.center = view.center
        indicator.startAnimating()
    }
}

extension VideoVC:YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        indicator.stopAnimating()
    }
}
