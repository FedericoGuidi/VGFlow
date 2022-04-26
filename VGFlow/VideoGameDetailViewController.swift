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
    @IBOutlet var videoGameDetailsLabel: UILabel!
    @IBOutlet var videoGameSummaryLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    
    var videogameCard: VideoGameCard!
    var videogame: VideoGame?
    
    init?(coder: NSCoder, videogame: VideoGameCard) {
        self.videogameCard = videogame
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
        videoGameNameLabel.text = videogameCard.name
        
        coverArtImageView.layer.cornerRadius = 20
        
        videoGameDetailRequestTask = Task {
            do {
                let videogame = try await VideoGameRequest(id: videogameCard.id).send()
                    updateDetails(with: videogame)
                
            } catch {
                print(error)
            }
            
            videoGameDetailRequestTask = nil
        }
    }

    func updateDetails(with videogame: VideoGame) {
        imageRequestTask = Task {
            if let url = videogame.cover?.imageURL,
                let image = try? await ImageRequest(path: url).send() {
                if image.size.width > image.size.height {
                    self.coverArtImageView.contentMode = .scaleAspectFit
                }
                self.coverArtImageView.image = image
            }
            imageRequestTask = nil
        }
        
        var company: String = ""
        if let publisherAndDeveloper = videogame.involvedCompanies.first(where: { $0.developer && $0.publisher })?.company.name {
            company = publisherAndDeveloper
        } else if let developer = videogame.involvedCompanies.first(where: { $0.developer })?.company.name {
            company = developer
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: videogame.releaseDate)
        videoGameDetailsLabel.text = [company, yearString].joined(separator: " • ")
        
        videoGameSummaryLabel.text = videogame.summary
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        let height = contentView.subviews.map { $0.bounds.size.height }.reduce(100, +)
        
        contentViewHeightConstraint.constant = height
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
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
