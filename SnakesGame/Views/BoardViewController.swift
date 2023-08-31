//
//  BoardViewController.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/04/26.
//

//import UIKit
//
//class BoardViewController: UIViewController {
//
//    let cols: Int = 9
//    let rows: Int = 7
//
//    let originX: CGFloat = 53
//    let originY: CGFloat = 71
//    let cellSide: CGFloat = 23
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    func drawGrid() {
//        let gridPath = UIBezierPath()
//        for i in 0...rows{
//            gridPath.move(to: CGPoint(x: originX, y: originY + CGFloat(i) * cellSide))
//            gridPath.addLine(to: CGPoint(x: originX + CGFloat(cols) * cellSide, y: originY + CGFloat(i) * cellSide ))
//        }
//
//        for i in 0...cols {
//            gridPath.move(to: CGPoint(x: originX, y: originY + CGFloat(i) * cellSide))
//            gridPath.addLine(to: CGPoint(x: originX + CGFloat(i) * cellSide, y: originY + CGFloat(rows) * cellSide ))
//        }
//        UIColor.lightGray.setStroke()
//        gridPath.stroke()
//    }
//}

import UIKit

class BoardViewController: UIViewController {
    let gridSize = 20 // Adjust this value to change the grid size
    let snakeSpeed = 0.3 // Adjust this value to change the snake speed
    
    var snakeView: UIView!
    var foodView: UIView!
    var snakeBody: [CGPoint] = []
    var currentDirection: Direction = .right
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }
    
    func setupGame() {
        let screenWidth = Int(view.bounds.width)
        let screenHeight = Int(view.bounds.height)
        
        // Calculate grid dimensions
        let gridWidth = screenWidth / gridSize
        let gridHeight = screenHeight / gridSize
        
        // Create a border view
            let borderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            borderView.layer.borderWidth = 1.0
            borderView.layer.borderColor = UIColor.black.cgColor
            view.addSubview(borderView)
        
        // Initialize snake body
           let startX = gridWidth / 2
           let startY = gridHeight / 2
           snakeBody.append(CGPoint(x: startX, y: startY))
        
        // Create snake view
        let snakeFrame = CGRect(x: startX * gridSize, y: startY * gridSize, width: gridSize, height: gridSize)
        snakeView = UIView(frame: snakeFrame)
        snakeView.backgroundColor = .green
        view.addSubview(snakeView)
        
        // Generate initial food position
        let foodX = Int(arc4random_uniform(UInt32(gridWidth)))
        let foodY = Int(arc4random_uniform(UInt32(gridHeight)))
        
        // Create food view
        let foodFrame = CGRect(x: foodX * gridSize, y: foodY * gridSize, width: gridSize, height: gridSize)
        foodView = UIView(frame: foodFrame)
        foodView.backgroundColor = .red
        view.addSubview(foodView)
        
        // Start the game loop
        timer = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
        // Add swipe gesture recognizers
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            if currentDirection != .down {
                currentDirection = .up
            }
        case .down:
            if currentDirection != .up {
                currentDirection = .down
            }
        case .left:
            if currentDirection != .right {
                currentDirection = .left
            }
        case .right:
            if currentDirection != .left {
                currentDirection = .right
            }
        default:
            break
        }
    }
    
    @objc func gameLoop() {
        moveSnake()
        
        if checkCollision() {
            gameOver()
        } else {
            if checkFoodCollision() {
                updateScore()
                updateFoodPosition()
            }
        }
    }
    
    func moveSnake() {
       
        // Get the head of the snake
        var head = snakeBody[0]
        
        // Calculate the new position of the head based on the current direction
        switch currentDirection {
        case .up:
            head.y -= 1
        case .down:
            head.y += 1
        case .left:
            head.x -= 1
        case .right:
            head.x += 1
        }
        
        // Wrap around the grid if the snake reaches the edge
        let screenWidth = Int(view.bounds.width)
        let screenHeight = Int(view.bounds.height)
        let gridWidth = screenWidth / gridSize
        let gridHeight = screenHeight / gridSize
        
        if head.x < 0 {
            head.x = CGFloat(gridWidth - 1)
        } else if head.x >= CGFloat(gridWidth) {
            head.x = 0
        }
        
        if head.y < 0 {
            head.y = CGFloat(gridHeight - 1)
        } else if head.y >= CGFloat(gridHeight) {
            head.y = 0
        }
        
        // Move the snake by updating the position of each body part
        for i in (1..<snakeBody.count).reversed() {
            snakeBody[i] = snakeBody[i-1]
        }
        snakeBody[0] = head
        
        // Update the position of the snake view
        snakeView.frame.origin.x = head.x * CGFloat(gridSize)
        snakeView.frame.origin.y = head.y * CGFloat(gridSize)
    }
    
    func checkCollision() -> Bool {
        let head = snakeBody[0]
        
        // Check if the snake has collided with itself
        for i in 1..<snakeBody.count {
            if snakeBody[i] == head {
                return true
            }
        }
        
        return false
    }
    
    func checkFoodCollision() -> Bool {
        let head = snakeBody[0]
        
        // Check if the snake has collided with the food
        return head == foodView.frame.origin
    }
    
    func updateScore() {
        // Increase the score and update the display
        // Implement your own scoring system here
    }
    
    func updateFoodPosition() {
        // Generate a new random position for the food
        let screenWidth = Int(view.bounds.width)
        let screenHeight = Int(view.bounds.height)
        let gridWidth = screenWidth / gridSize
        let gridHeight = screenHeight / gridSize
        
        let foodX = Int(arc4random_uniform(UInt32(gridWidth)))
        let foodY = Int(arc4random_uniform(UInt32(gridHeight)))
        
        foodView.frame.origin.x = CGFloat(foodX * gridSize)
        foodView.frame.origin.y = CGFloat(foodY * gridSize)
    }
    
    func gameOver() {
        // Stop the game loop and perform any necessary actions when the game is over
        timer?.invalidate()
        
        let alertController = UIAlertController(title: "Game Over", message: "You lost!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
            self.resetGame()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func resetGame() {
        // Reset the game state
        snakeBody = []
        currentDirection = .right
        snakeView.removeFromSuperview()
        foodView.removeFromSuperview()
        setupGame()
    }
}

// Enum to represent the possible directions of the snake
enum Direction {
    case up, down, left, right
}
