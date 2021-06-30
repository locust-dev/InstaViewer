//
//  UIViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 30.06.2021.
//

import UIKit
import AVKit

extension UIViewController {
    func play(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let vc = AVPlayerViewController()
        vc.player = AVPlayer(url: url)
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}
