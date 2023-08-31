//
//  SnakeGameViewController.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/05/04.
//

import UIKit
import AVFoundation

class SnakeGameViewController: UIViewController {
    
    private var gameView: UIImageView!
    private var scoreLabel: UILabel!
    private var winStreakLabel: UILabel!
//    private var winTimeLabel: UILabel!
    private var restartButton: UIButton!
    private var quitButton: UIButton!
    private var settingsButton: UIButton!
    private var pauseButton: UIButton!
    private var settingsView: UIView!

    private var timeElapsed: TimeInterval = 0
    private var timeLabel: UILabel!
    
    private var snakeBody: [UIView] = []
    private var snakeDirection: SnakeDirection = .right
    private var foodView: UIImageView!
    private var score: Int = 0
    
    private var isPaused = false

    private var winStreak: Int = 0
    private var snakeSpeed: TimeInterval = 0.1
    private var gameTimer: Timer?
    private var resumeTimeInterval: TimeInterval?
    
    private var level: Level?
   
    private var audioPlayer: AVAudioPlayer?
    private var volumeSwitch: UISwitch!

    private var foodSize: CGFloat = 90
    private var isAudioPlaying = false
    
    private var backgroundImageName: String = "seam"

    private var backButton: UIButton!
    private var eatingSoundEffect: AVAudioPlayer?
        private var collisionSoundEffect: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSoundEffects()
        updateGameViewBackground()
        //        setupLevel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLevel(with: Level1View())
//        setupLevel(with: Level2View())
    }
    
    private func loadSoundEffects() {
           // Load eating sound effect
           if let eatingSoundURL = Bundle.main.url(forResource: "eating_sound", withExtension: "mp3") {
               do {
                   eatingSoundEffect = try AVAudioPlayer(contentsOf: eatingSoundURL)
                   eatingSoundEffect?.prepareToPlay()
               } catch {
                   print("Failed to load eating sound effect:", error)
               }
           }

           // Load collision sound effect
           if let collisionSoundURL = Bundle.main.url(forResource: "Bonk", withExtension: "mp3") {
               do {
                   collisionSoundEffect = try AVAudioPlayer(contentsOf: collisionSoundURL)
                   collisionSoundEffect?.prepareToPlay()
               } catch {
                   print("Failed to load collision sound effect:", error)
               }
           }
       }
    /*-------------------------------------------*/
    
    private func setupLevel(with levelView: Level) {
//        let levelView = Level1View(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        levelView.isUserInteractionEnabled = false
        levelView.translatesAutoresizingMaskIntoConstraints = false
        gameView.addSubview(levelView)
        NSLayoutConstraint.activate([
            self.gameView.topAnchor.constraint(equalTo: levelView.topAnchor),
            self.gameView.leftAnchor.constraint(equalTo: levelView.leftAnchor),
            self.gameView.rightAnchor.constraint(equalTo: levelView.rightAnchor),
            self.gameView.bottomAnchor.constraint(equalTo: levelView.bottomAnchor)
        ])
        level = levelView
    }

    /*-------------------------------------------*/
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.gameView.transform = CGAffineTransform(rotationAngle: size.width > size.height ? .pi / 2 : 0)
        }
    }
    
    private func updateGameViewBackground() {
        gameView.image = UIImage(named: backgroundImageName)
    }

    /*-------------------------------------------*/
    
    private func setupUI() {
        gameView = UIImageView()
        gameView.image = UIImage(named: "seam")
        gameView.backgroundColor = .systemPink
        view.addSubview(gameView)
        gameView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                gameView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 170),
                gameView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                gameView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                gameView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -180)
            ])
        } else {
            NSLayoutConstraint.activate([
                gameView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 170),
                gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                gameView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -180)
            ])
        }
        
        timeLabel = UILabel()
                  timeLabel.textColor = .white
                  timeLabel.font = UIFont.systemFont(ofSize: 20)
        timeLabel.textAlignment = .right
                  view.addSubview(timeLabel)
                  timeLabel.translatesAutoresizingMaskIntoConstraints = false
                  NSLayoutConstraint.activate([
                    timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                  ])
        scoreLabel = UILabel()
            scoreLabel.textColor = .white
            scoreLabel.font = UIFont.systemFont(ofSize: 20)
            scoreLabel.textAlignment = .center
            scoreLabel.text = "Score: 0"
            view.addSubview(scoreLabel)
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        
        winStreakLabel = UILabel()
           winStreakLabel.textColor = .white
           winStreakLabel.font = UIFont.systemFont(ofSize: 20)
           winStreakLabel.textAlignment = .left
            winStreakLabel.text = "HighScore: 0"
           winStreakLabel.backgroundColor = .clear
           view.addSubview(winStreakLabel)
           winStreakLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            winStreakLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            winStreakLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            winStreakLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//               winStreakLabel.heightAnchor.constraint(equalToConstant: 100)
           ])
        
        restartButton = UIButton(type: .system)
          restartButton.setTitle("Restart", for: .normal)
          restartButton.setTitleColor(.white, for: .normal)
          restartButton.backgroundColor = .green
          restartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
          restartButton.layer.cornerRadius = 5
          restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
          view.addSubview(restartButton)
          restartButton.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              restartButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
              restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
              restartButton.widthAnchor.constraint(equalToConstant: 100),
              restartButton.heightAnchor.constraint(equalToConstant: 30)
          ])

          quitButton = UIButton(type: .system)
          quitButton.setTitle("Quit", for: .normal)
          quitButton.setTitleColor(.white, for: .normal)
          quitButton.backgroundColor = .red
          quitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
          quitButton.layer.cornerRadius = 5
          quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
          view.addSubview(quitButton)
          quitButton.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              quitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
              quitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
              quitButton.widthAnchor.constraint(equalToConstant: 100),
              quitButton.heightAnchor.constraint(equalToConstant: 30)
          ])

          pauseButton = UIButton(type: .system)
          pauseButton.setTitle("Pause", for: .normal)
          pauseButton.setTitleColor(.white, for: .normal)
          pauseButton.backgroundColor = .orange
          pauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
          pauseButton.layer.cornerRadius = 5
          pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
          view.addSubview(pauseButton)
          pauseButton.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally,
              pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110),
              pauseButton.widthAnchor.constraint(equalToConstant: 100),
              pauseButton.heightAnchor.constraint(equalToConstant: 30)
          ])

        settingsButton = UIButton(type: .system)
           settingsButton.setTitle("Settings", for: .normal)
           settingsButton.setTitleColor(.white, for: .normal)
           settingsButton.backgroundColor = .blue
           settingsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           settingsButton.layer.cornerRadius = 5
           settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
           view.addSubview(settingsButton)
           settingsButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
               settingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
               settingsButton.widthAnchor.constraint(equalToConstant: 100),
               settingsButton.heightAnchor.constraint(equalToConstant: 30)
           ])
        
        // Add a settings view with customizations
        settingsView = UIView()
        settingsView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.7)
        settingsView.isHidden = true
        view.addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.layer.cornerRadius = 5
        backButton.backgroundColor = UIColor.green
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        settingsView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 150),
            backButton.topAnchor.constraint(equalTo: settingsView.safeAreaLayoutGuide.topAnchor, constant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let backgroundImageControl = UISegmentedControl(items: ["Grass", "Water", "Desert"])
            backgroundImageControl.selectedSegmentIndex = 0 // Set the initial selection
            backgroundImageControl.addTarget(self, action: #selector(backgroundImageControlValueChanged), for: .valueChanged)
            settingsView.addSubview(backgroundImageControl)
            backgroundImageControl.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backgroundImageControl.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
                backgroundImageControl.centerYAnchor.constraint(equalTo: settingsView.centerYAnchor, constant: -150),
                backgroundImageControl.widthAnchor.constraint(equalToConstant: 200),
                backgroundImageControl.heightAnchor.constraint(equalToConstant: 30)
            ])
        
//        // Add a sound effect volume slider
//        let soundEffectVolumeSlider = UISlider()
//        soundEffectVolumeSlider.minimumValue = 0.0
//        soundEffectVolumeSlider.maximumValue = 1.0
//        soundEffectVolumeSlider.value = audioPlayer?.volume ?? 0.5 // Set the initial value based on the audio player's volume
//        soundEffectVolumeSlider.addTarget(self, action: #selector(soundEffectVolumeSliderValueChanged(_:)), for: .valueChanged)
//        settingsView.addSubview(soundEffectVolumeSlider)
//        soundEffectVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            soundEffectVolumeSlider.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
//            soundEffectVolumeSlider.centerYAnchor.constraint(equalTo: settingsView.centerYAnchor),
//            soundEffectVolumeSlider.widthAnchor.constraint(equalToConstant: 200),
//            soundEffectVolumeSlider.heightAnchor.constraint(equalToConstant: 30)
//        ])
                                          }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGame()
    }
  /*-------------------------------------------*/
    
    /*-------------------------------------------*/
    
    private func startGame() {
        gameTimer?.invalidate()
        restartButton.isHidden = false
        quitButton.isHidden = false
        isPaused = false
        timeElapsed = 0
            pauseButton.isHidden = false
        
            updateTimeLabel()
            startTimer()
        
        score = 0
//        winStreak = 0
        snakeSpeed = 0.2
        
        scoreLabel.text = "Score: \(score)"
        winStreakLabel.text = "Win Streak: \(winStreak)"
        
        clearGame()
        createSnake(at: CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY))
        createFood()
        
        gameTimer = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        gameView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        gameView.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        gameView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        gameView.addGestureRecognizer(swipeRight)
        
        gameView.isUserInteractionEnabled = true
    }
    
    /*-------------------------------------------*/
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        
        switch direction {
        case .up:
            if snakeDirection != .down {
                snakeDirection = .up
            }
        case .down:
            if snakeDirection != .up {
                snakeDirection = .down
            }
        case .left:
            if snakeDirection != .right {
                snakeDirection = .left
            }
        case .right:
            if snakeDirection != .left {
                snakeDirection = .right
            }
        default:
            break
        }
    }

    private func clearGame() {
        for bodyPart in snakeBody {
            bodyPart.removeFromSuperview()
        }
        snakeBody.removeAll()
        
        foodView?.removeFromSuperview()
        foodView = nil
        
        gameTimer?.invalidate()
    }
    
    /*-------------------------------------------*/
    
    private func createSnake(at position: CGPoint) {
        // Create head view
        let headView = UIImageView(frame: CGRect(x: position.x, y: position.y, width: 10, height: 10))
        headView.image = UIImage(named: "snake-head")
        gameView.addSubview(headView)

        // Create tail view
        let tailView = UIImageView(frame: CGRect(x: position.x - 10, y: position.y, width: 10, height: 10))
        tailView.image = UIImage(named: "snake-tail")
        gameView.addSubview(tailView)

        // Create animation for the head view
        UIView.animate(withDuration: snakeSpeed, delay: 0, options: [.repeat, .autoreverse], animations: {
            headView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)

        // Create animation for the tail view
        UIView.animate(withDuration: snakeSpeed, delay: snakeSpeed / 2, options: [.repeat, .autoreverse], animations: {
            tailView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)

        // Add head and tail views to the snake body
        snakeBody.append(headView)
        snakeBody.append(tailView)
    }

    /*-------------------------------------------*/
    
    private func createFood() {
        let randomX = CGFloat(arc4random_uniform(UInt32(gameView.bounds.width - foodSize)))
        let randomY = CGFloat(arc4random_uniform(UInt32(gameView.bounds.height - foodSize)))

        let foodFrame = CGRect(x: randomX, y: randomY, width: foodSize, height: foodSize)
        foodView = UIImageView(frame: foodFrame)
        foodView.image = UIImage(named: "apple") // Replace "foodImage" with the name of your food image
        gameView.addSubview(foodView)
    }

    /*-------------------------------------------*/
    
    @objc private func gameLoop() {
        moveSnake()
        timeElapsed += snakeSpeed
            updateTimeLabel()
        
        if isPaused {
                return
            }
        
        if checkCollision() {
            playCollisionSoundEffect()
           
            endGame()
            return
        }
        
        if checkFoodCollision() {
            
            updateScore()
            growSnake()
            createFood()
            playEatingSoundEffect()
            increaseSnakeSpeed()
        }
        
        // Check if the foodView is nil and create a new food
           if foodView == nil {
               createFood()
           }
    }
    
    private func playEatingSoundEffect() {
           eatingSoundEffect?.play()
       }

       private func playCollisionSoundEffect() {
           collisionSoundEffect?.play()
       }
   
    /*-------------------------------------------*/
    
    private func moveSnake() {
        var newHeadFrame = snakeBody[0].frame
        
        switch snakeDirection {
        case .up:
            newHeadFrame.origin.y -= newHeadFrame.size.height
        case .down:
            newHeadFrame.origin.y += newHeadFrame.size.height
        case .left:
            newHeadFrame.origin.x -= newHeadFrame.size.width
        case .right:
            newHeadFrame.origin.x += newHeadFrame.size.width
        }
        
        let newHead = UIView(frame: newHeadFrame)
        newHead.backgroundColor = .green
        
        gameView.addSubview(newHead)
        snakeBody.insert(newHead, at: 0)
        
        let tail = snakeBody.removeLast()
        tail.removeFromSuperview()
    }
    
    /*-------------------------------------------*/
    
    private func checkCollision() -> Bool {
            guard let head = snakeBody.first
            else { return false }
            
            if head.frame.origin.x < 0 || head.frame.origin.x + head.frame.size.width > gameView.bounds.width ||
                head.frame.origin.y < 0 || head.frame.origin.y + head.frame.size.height > gameView.bounds.height {
                gameOver()
                return true
            }
            
            for view in level?.boundaries ?? [] {
                if head.frame.intersects(view.frame) {
                    gameOver()
                    return true
                }
            }
            
            for bodyPart in 1..<snakeBody.count {
                
                if head.frame.intersects(snakeBody[bodyPart].frame) {
                    return true
                }
            }
            
            return false
        foodSize = 90
        }
    
    /*-------------------------------------------*/
    private func checkFoodCollision() -> Bool {
    guard let head = snakeBody.first, let food = foodView
        else {
            return false
        }
        let collision = head.frame.intersects(food.frame)
        
        if collision {
            food.removeFromSuperview() // Remove the food view from the game view
            foodSize -= 5
            foodView = nil // Set the foodView reference to nil
            if foodSize < 20 {
                        foodSize = 20 // Limit the minimum food size
                
                    }
        }
        
        return collision
    }
    /*-------------------------------------------*/
    
    @objc private func settingsButtonTapped() {
        
//        isPaused = true
        
        if isPaused {
            isPaused = false
//            dismiss(animated: true, completion: nil)
            return
        }
        
        if isPaused {
            // Resume the game
            if let resumeTime = resumeTimeInterval {
                // If the game was previously paused, resume from where it left off
                gameTimer = Timer.scheduledTimer(withTimeInterval: resumeTime, repeats: true, block: { [weak self] _ in
                    self?.gameLoop()
                })
            } else {
                // If the game was not previously paused, start a new timer
                gameTimer = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
            }
            isPaused = false
            pauseButton.setTitle("Pause", for: .normal)
        }
            else {
            // Pause the game
            gameTimer?.invalidate()
            isPaused = true
            pauseButton.setTitle("Resume", for: .normal)
        }
//        settingsView.isHidden = !settingsView.isHidden
        settingsView.isHidden = false

        backButton.isHidden = false
        let alertController = UIAlertController(title: "Snake Settings", message: nil, preferredStyle: .alert)
    }
    
    /*-------------------------------------------*/
    
    private func updateScore() {
        score += 1
        if winStreak < score {
            winStreak += 1
        }
        scoreLabel.text = "Score: \(score)"
                winStreakLabel.text = "Win Streak: \(winStreak)"
    }
    
    /*-------------------------------------------*/
    
    private func increaseSnakeSpeed() {
        if score > 0 && score % 1 == 0 {
            snakeSpeed -= 0.01
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        }
    }
    
    /*-------------------------------------------*/
    
    private func growSnake() {
        guard let tail = snakeBody.first
        else {
        return }
        
        let tailFrame = tail.frame
        
        let newTail = UIView(frame: tailFrame)
        newTail.backgroundColor = .black
        
        gameView.addSubview(newTail)
        snakeBody.append(newTail)
    }
    
    /*-------------------------------------------*/
    
    private func endGame() {
        restartButton.isHidden = false
        quitButton.isHidden = false
        stopTimer()
        
        gameTimer?.invalidate()
        gameTimer = nil
    }
    /*-------------------------------------------*/
    
    func gameOver() {
    
            let alertController = UIAlertController(title: "Game Over", message: "You lost!", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
                self.startGame()
            }
        foodSize = 90
            alertController.addAction(restartAction)
            present(alertController, animated: true, completion: nil)
        }
    /*-------------------------------------------*/
    
    @objc private func restartButtonTapped() {
        
        // Reset the foodSize to 90
           foodSize = 90
           // Call the startGame function to restart the game
           startGame()
        
        let alertController = UIAlertController(title: "Restart Game", message: "Are you sure you want to Restart?", preferredStyle: .alert)
                 
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
                  
        alertController.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { (action) in
        }))
    }
    
    /*-------------------------------------------*/
    
    @objc private func quitButtonTapped() {
        
        if isPaused {
            isPaused = true
            dismiss(animated: true, completion: nil)
            return
        }
        
        if isPaused {
            // Resume the game
            if let resumeTime = resumeTimeInterval {
                // If the game was previously paused, resume from where it left off
                gameTimer = Timer.scheduledTimer(withTimeInterval: resumeTime, repeats: true, block: { [weak self] _ in
                    self?.gameLoop()
                })
            } else {
                // If the game was not previously paused, start a new timer
                gameTimer = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
            }
            isPaused = false
            pauseButton.setTitle("Pause", for: .normal)
        }
            else {
            // Pause the game
            gameTimer?.invalidate()
            isPaused = true
            pauseButton.setTitle("Resume", for: .normal)
        }

        isPaused = true
        let alertController = UIAlertController(title: "Quit Game", message: "Are you sure you want to quit?", preferredStyle: .alert)
        
            
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//            self.isPaused = false
        }))
                  
        alertController.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { (action) in
//            self.clearGame()
//            self.startGame()
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }

    /*-------------------------------------------*/
    
    @objc private func pauseButtonTapped() {
        if isPaused {
            // Resume the game
            if let resumeTime = resumeTimeInterval {
                // If the game was previously paused, resume from where it left off
                gameTimer = Timer.scheduledTimer(withTimeInterval: resumeTime, repeats: true, block: { [weak self] _ in
                    self?.gameLoop()
                })
                
                settingsView.isHidden = true
                        backButton.isHidden = true
            } else {
                // If the game was not previously paused, start a new timer
                gameTimer = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
            }
            isPaused = false
            pauseButton.setTitle("Pause", for: .normal)
        } else {
            // Pause the game
            gameTimer?.invalidate()
            isPaused = true
            pauseButton.setTitle("Resume", for: .normal)
            settingsView.isHidden = true
                    backButton.isHidden = true
        }
    }
    
    @objc private func soundEffectVolumeSliderValueChanged(_ sender: UISlider) {
        let volume = sender.value
        audioPlayer?.volume = volume
    }

    
    @objc private func backButtonTapped() {
        settingsView.isHidden = true
    }

    /*-------------------------------------------*/
    private func updateTimeLabel() {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        timeLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.timeElapsed += 1
            self?.updateTimeLabel()
        }
    }
    
    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    /*-------------------------------------------*/
    
//    @objc private func volumeSwitchToggled(_ sender: UISwitch) {
//        if sender.isOn {
//            audioPlayer?.volume = 1.0 // full volume
//        } else {
//            audioPlayer?.volume = 0.0 // muted
//        }
//    }
//
//    @objc private func volumeSwitchValueChanged() {
//        // Handle volume switch value changed
//        let isVolumeOn = volumeSwitch.isOn
//        // Adjust the volume of the audio player or perform any other related actions
//    }
//
//    @objc private func playButtonTapped() {
//        // Handle play button tapped
//        if !isAudioPlaying {
//            // Start playing the audio
//            isAudioPlaying = true
//            // Code to play audio
//        }
//    }
//
//    @objc private func pauseAudioButtonTapped() {
//        // Handle pause audio button tapped
//        if isAudioPlaying {
//            // Pause the audio
//            isAudioPlaying = false
//            // Code to pause audio
//        }
//    }

    @objc private func backgroundImageControlValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            backgroundImageName = "seam"
        case 1:
            backgroundImageName = "blueWater"
        case 2:
            backgroundImageName = "desert2"
        default:
            break
        }
        
        updateGameViewBackground()
    }
}

enum SnakeDirection {
    case up, down, left, right
}
