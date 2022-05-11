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
    @IBOutlet var videoGameSummaryLabel: UILabel!
    @IBOutlet var videoGameStorylineLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var starRatingView: UIStarRatingView!
    @IBOutlet var averageStarRatingLabel: UILabel!
    @IBOutlet var averageStarRatingStackView: UIStackView!
    
    @IBOutlet var gameButtonsStackView: UIStackView!
    
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
    
    @IBOutlet var platformsLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var developersLabel: UILabel!
    @IBOutlet var publishersLabel: UILabel!
    
    var videogameCard: VideoGameCard!
    var videogame: VideoGame?
    var videogameDetails: VideoGameDetails?
    
    enum Source {
        case videoGameCard(_ videogame: VideoGameCard)
        case upcomingGame(_ videogame: UpcomingGame)
        case trendingGame(_ videogame: TrendingGame)
    }
    
    init?(coder: NSCoder, source: Source) {
        switch source {
        case .videoGameCard(let vg):
            self.videogameCard = vg
        case .upcomingGame(let vg):
            let vgc = VideoGameCard(id: vg.id, name: vg.name)
            self.videogameCard = vgc
        case .trendingGame(let vg):
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
        starRatingView.isHidden = true
        averageStarRatingStackView.isHidden = true
        gameButtonsStackView.isHidden = true
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
        
        /*var company: String = ""
        if let publisherAndDeveloper = videogame.involvedCompanies?.first(where: { $0.developer && $0.publisher })?.company.name {
            company = publisherAndDeveloper
        } else if let developer = videogame.involvedCompanies?.first(where: { $0.developer })?.company.name {
            company = developer
        }*/
        
        if let companies = videogame.involvedCompanies {
            developersLabel.text = companies.filter { $0.developer }.map { $0.company.name }.joined(separator: ", ")
            publishersLabel.text = companies.filter { $0.publisher }.map { $0.company.name }.joined(separator: ", ")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM y"
        releaseDateLabel.text = dateFormatter.string(from: videogame.releaseDate)
        
        platformsLabel.text = videogame.platforms!.map { $0.name }.joined(separator: ", ")
        
        genresLabel.text = videogame.genres.map { $0.name }.joined(separator: ", ")
        
        videoGameSummaryLabel.text = videogame.summary
        videoGameStorylineLabel.text = videogame.storyline
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private func updateRatingsDetails(with details: VideoGameDetails) {
        var startingPoint = 50.0
        if let status = details.status {
            starRatingView.isHidden = false
            starRatingView.setNeedsLayout()
            starRatingView.layoutIfNeeded()
            
            averageStarRatingStackView.isHidden = false
            averageStarRatingStackView.setNeedsLayout()
            averageStarRatingStackView.layoutIfNeeded()
            
            gameButtonsStackView.isHidden = false
            gameButtonsStackView.setNeedsLayout()
            gameButtonsStackView.layoutIfNeeded()
            
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
            let today = Date()
            if let date = videogame?.releaseDate {
                if date < today {
                    self.addToLibraryButton.isHidden = false
                    self.averageStarRatingStackView.isHidden = false
                }
            }
        }
        
        if let rating = details.starRating {
            self.starRatingView.starColor = .systemYellow
            self.starRatingView.rating = rating
        }
        
        if let averageStarRating = videogameDetails?.averageStarRating {
            averageStarRatingLabel.text = String(averageStarRating)
        }
       
        gameplayLabel.text = PercentLabel(details.averageGameRating?.gameplay ?? 0)
        plotLabel.text = PercentLabel(details.averageGameRating?.plot ?? 0)
        musicLabel.text = PercentLabel(details.averageGameRating?.music ?? 0)
        graphicsLabel.text = PercentLabel(details.averageGameRating?.graphics ?? 0)
        levelDesignLabel.text = PercentLabel(details.averageGameRating?.levelDesign ?? 0)
        longevityLabel.text = PercentLabel(details.averageGameRating?.longevity ?? 0)
        iaLabel.text = PercentLabel(details.averageGameRating?.ia ?? 0)
        physicsLabel.text = PercentLabel(details.averageGameRating?.physics ?? 0)
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        let height = contentView.subviews.map { $0.bounds.size.height }.reduce(startingPoint, +)
        
        contentViewHeightConstraint.constant = height
    }
    
    private func PercentLabel(_ number: Float) -> String {
        return String(Int(ceil(number * 100))) + "%"
    }
    
    private func updateButtonPercent(_ button: GameRatingButton) {
        let value = Float(button.isSelected ? 1.0 : -1.0)
        
        switch button {
        case gameplayButton:
            let average = videogameDetails?.averageGameRating?.gameplay ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.gameplay = newAverage
            gameplayLabel.text = PercentLabel(newAverage)
        case plotButton:
            let average = videogameDetails?.averageGameRating?.plot ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.plot = newAverage
            plotLabel.text = PercentLabel(newAverage)
        case musicButton:
            let average = videogameDetails?.averageGameRating?.music ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.music = newAverage
            musicLabel.text = PercentLabel(newAverage)
        case graphicsButton:
            let average = videogameDetails?.averageGameRating?.graphics ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.graphics = newAverage
            graphicsLabel.text = PercentLabel(newAverage)
        case levelDesignButton:
            let average = videogameDetails?.averageGameRating?.levelDesign ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.levelDesign = newAverage
            levelDesignLabel.text = PercentLabel(newAverage)
        case longevityButton:
            let average = videogameDetails?.averageGameRating?.longevity ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.longevity = newAverage
            longevityLabel.text = PercentLabel(newAverage)
        case iaButton:
            let average = videogameDetails?.averageGameRating?.ia ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.ia = newAverage
            iaLabel.text = PercentLabel(newAverage)
        case physicsButton:
            let average = videogameDetails?.averageGameRating?.physics ?? 0
            let newAverage = calcNewAverage(adding: value, to: average)
            videogameDetails?.averageGameRating?.physics = newAverage
            physicsLabel.text = PercentLabel(newAverage)
        default:
            break
        }
    }
    
    private func calcNewAverage(adding value: Float, to average: Float) -> Float {
        let totalCount = Float(videogameDetails?.gameRatingCount ?? 0)
        return ((totalCount * average) + value) / totalCount
    }
    
    @IBAction func gameRatingButtonClicked(_ sender: GameRatingButton) {
        let userGameRating = UserGameRating(user: KeychainItem.currentUserIdentifier,
                                            videogameId: self.videogame!.id,
                                            gameplay: gameplayButton.isSelected ? 1 : 0,
                                            plot: plotButton.isSelected ? 1 : 0,
                                            music: musicButton.isSelected ? 1 : 0,
                                            graphics: graphicsButton.isSelected ? 1 : 0,
                                            levelDesign: levelDesignButton.isSelected ? 1 : 0,
                                            longevity: longevityButton.isSelected ? 1 : 0,
                                            ia: iaButton.isSelected ? 1 : 0,
                                            physics: physicsButton.isSelected ? 1 : 0)
        Task {
            try? await RateVideoGameByGameRatingRequest(gameRating: userGameRating).send()
        }
        
        updateButtonPercent(sender)
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
