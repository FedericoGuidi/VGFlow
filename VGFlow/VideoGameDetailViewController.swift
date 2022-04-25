//
//  VideoGameDetailViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import UIKit

class VideoGameDetailViewController: UIViewController {

    var imageRequestTask: Task<Void, Never>? = nil
    var videoGameDetailRequestTask: Task<Void, Never>? = nil
    
    deinit {
        imageRequestTask?.cancel()
        videoGameDetailRequestTask?.cancel()
    }
    
    @IBOutlet var videoGameNameLabel: UILabel!
    @IBOutlet var coverArtImageView: UIImageView!
    
    var videogame: VideoGameCard!
    
    init?(coder: NSCoder, videogame: VideoGameCard) {
        self.videogame = videogame
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        videoGameNameLabel.font = FontKit.roundedFont(ofSize: 28, weight: .heavy)
        videoGameNameLabel.text = videogame.name
        
        coverArtImageView.layer.cornerRadius = 20
        
        imageRequestTask = Task {
            if let url = videogame.coverURL,
                let image = try? await ImageRequest(path: url).send() {
                if image.size.width > image.size.height {
                    self.coverArtImageView.contentMode = .scaleAspectFit
                }
                self.coverArtImageView.image = image
            }
            imageRequestTask = nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
