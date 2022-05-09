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
    var videoGameUserDetailsRequestTask: Task<Void, Never>? = nil
    
    deinit {
        imageRequestTask?.cancel()
        videoGameDetailRequestTask?.cancel()
        videoGameUserDetailsRequestTask?.cancel()
    }
    
    @IBOutlet var videoGameNameLabel: UILabel!
    @IBOutlet var coverArtImageView: UIImageView!
    @IBOutlet var videoGameDetailsLabel: UILabel!
    @IBOutlet var videoGameSummaryLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var starRatingView: UIStarRatingView!
    
    @IBOutlet var heartButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
    // MARK: Game status labels
    @IBOutlet var gameStatusStackView: UIStackView!
    @IBOutlet var gameTimeStackView: UIStackView!
    @IBOutlet var addToLibraryButton: UIButton!
    
    // MARK: GameRating button outlets
    @IBOutlet var gameplayButton: GameRatingButton!
    @IBOutlet var plotButton: GameRatingButton!
    @IBOutlet var musicButton: GameRatingButton!
    @IBOutlet var graphicsButton: GameRatingButton!
    @IBOutlet var levelDesignButton: GameRatingButton!
    @IBOutlet var longevityButton: GameRatingButton!
    @IBOutlet var iaButton: GameRatingButton!
    @IBOutlet var physicsButton: GameRatingButton!
    
    // MARK: GameRating label outlets
    @IBOutlet var gameplayLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var musicLabel: UILabel!
    @IBOutlet var graphicsLabel: UILabel!
    @IBOutlet var levelDesignLabel: UILabel!
    @IBOutlet var longevityLabel: UILabel!
    @IBOutlet var iaLabel: UILabel!
    @IBOutlet var physicsLabel: UILabel!
    
    var videogameCard: VideoGameCard!
    var videogame: VideoGame?
    var videogameDetails: VideoGameDetails?
    
    enum Source {
        case videoGameCard(_ videogame: VideoGameCard)
        case upcomingGame(_ videogame: UpcomingGame)
    }
    
    init?(coder: NSCoder, source: Source) {
        switch source {
        case .videoGameCard(let vg):
            self.videogameCard = vg
        case .upcomingGame(let vg):
            let vgc = VideoGameCard(id: vg.id, name: vg.name)
            self.videogameCard = vgc
        }
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
        gameStatusStackView.isHidden = true
        gameTimeStackView.isHidden = true
        addToLibraryButton.isHidden = true
        navigationItem.rightBarButtonItems = nil
        
        videoGameNameLabel.font = FontKit.roundedFont(ofSize: 28, weight: .heavy)
        videoGameNameLabel.text = videogameCard.name
        
        coverArtImageView.layer.cornerRadius = 20
        starRatingView.videoGameId = videogameCard.id
        
        gameStatusStackView.layer.cornerRadius = gameStatusStackView.bounds.height / 2
        gameTimeStackView.layer.cornerRadius = gameTimeStackView.bounds.height / 2
        
        videoGameDetailRequestTask = Task {
            do {
                let videogame = try await VideoGameRequest(id: videogameCard.id).send()
                    updateDetails(with: videogame)
                self.videogame = videogame
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
        
        videoGameUserDetailsRequestTask = Task {
            if let details = try? await VideoGameDetailsRequest(videogameId: videogame.id).send() {
                self.videogameDetails = details
                updateRatingsDetails(with: details)
            }
            videoGameUserDetailsRequestTask = nil
        }
        
        var company: String = ""
        if let publisherAndDeveloper = videogame.involvedCompanies?.first(where: { $0.developer && $0.publisher })?.company.name {
            company = publisherAndDeveloper
        } else if let developer = videogame.involvedCompanies?.first(where: { $0.developer })?.company.name {
            company = developer
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: videogame.releaseDate)
        videoGameDetailsLabel.text = [company, yearString].joined(separator: " • ")
        
        videoGameSummaryLabel.text = videogame.summary
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private func updateRatingsDetails(with details: VideoGameDetails) {
        var startingPoint = 100.0
        if let status = details.status {
            startingPoint = 70.0
            navigationItem.rightBarButtonItems = [editButton, heartButton]
            
            self.gameStatusStackView.isHidden = false
            let image = self.gameStatusStackView.subviews[0] as! UIImageView
            image.image = status.properties.0
            gameStatusStackView.backgroundColor = status.properties.1
            let label = self.gameStatusStackView.subviews[1] as! UILabel
            label.text = "\(status.properties.2)"
            
            if let hours = details.hours {
                self.gameTimeStackView.isHidden = false
                let label = self.gameTimeStackView.subviews[1] as! UILabel
                label.text = "Giocato per \(hours) ore"
            }
            
            if let gameRating = details.gameRating {
                if gameRating.gameplay > 0 { gameplayButton.isSelected = true }
                if gameRating.plot > 0 { plotButton.isSelected = true }
                if gameRating.music > 0 { musicButton.isSelected = true }
                if gameRating.graphics > 0 { graphicsButton.isSelected = true }
                if gameRating.levelDesign > 0 { levelDesignButton.isSelected = true }
                if gameRating.longevity > 0 { longevityButton.isSelected = true }
                if gameRating.ia > 0 { iaButton.isSelected = true }
                if gameRating.physics > 0 { physicsButton.isSelected = true }
            }
        } else {
            self.addToLibraryButton.isHidden = false
        }
        
        if let rating = details.starRating {
            self.starRatingView.starColor = .systemYellow
            self.starRatingView.rating = rating
        }
       
        gameplayLabel.text = PercentLabel(details.averageGameRating?.gameplay ?? 0)
        plotLabel.text = PercentLabel(details.averageGameRating?.plot ?? 0)
        musicLabel.text = PercentLabel(details.averageGameRating?.music ?? 0)
        graphicsLabel.text = PercentLabel(details.averageGameRating?.graphics ?? 0)
        levelDesignLabel.text = PercentLabel(details.averageGameRating?.levelDesign ?? 0)
        longevityLabel.text = PercentLabel(details.averageGameRating?.longevity ?? 0)
        iaLabel.text = PercentLabel(details.averageGameRating?.ia ?? 0)
        physicsLabel.text = PercentLabel(details.averageGameRating?.physics ?? 0)
        
        let height = contentView.subviews.map { $0.bounds.size.height }.reduce(startingPoint, +)
        
        contentViewHeightConstraint.constant = height
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private func PercentLabel(_ number: Float) -> String {
        return String(Int(ceil(number * 100))) + "%"
    }
    
    private func updateButtonStatusOn(_ button: UIButton) {
        
    }
    
    private func updateButtonStatusOff(_ button: UIButton) {
        
    }
    
    @IBAction func gameRatingButtonClicked(_ sender: GameRatingButton) {
        if sender.isSelected {
            updateButtonStatusOff(sender)
        } else {
            updateButtonStatusOn(sender)
        }
    }
    
    @IBSegueAction func addEditVideoGameDetails(_ coder: NSCoder, sender: Any?) -> AddEditVideoGameViewController? {
        
        let controller = AddEditVideoGameViewController(coder: coder)
        
        controller?.videoGame = videogame
        controller?.videoGameDetails = videogameDetails
        
        return controller
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
