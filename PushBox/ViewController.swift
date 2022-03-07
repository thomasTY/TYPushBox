//
//  ViewController.swift
//  PushBox
//
//  Created by TYOU on 2022/3/6.
// 推箱子游戏-控制器

import UIKit

enum Direction: UInt {
    case up = 1 // 上
    case down // 下
    case left // 左
    case right // 右
}

class ViewController: UIViewController {
    let container = UIView() // 地图容器视图
    let titleLabel: UILabel = { // 标题
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20.0, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    let upButton:UIButton = { // 向上按钮
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage(named: "up"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(upClick), for: .touchUpInside)
        return button
    }()
    let downButton:UIButton = { // 向下按钮
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage(named: "down"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(downClick), for: .touchUpInside)
        return button
    }()
    let leftButton:UIButton = { // 向左按钮
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage(named: "left"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        return button
    }()
    let rightButton:UIButton = { // 向右按钮
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage(named: "right"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return button
    }()
    let resetButton:UIButton = { // 重置按钮
        let button = UIButton()
        button.setTitle("重置", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .regular)
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    let lastLevelButton:UIButton = { // 上一关按钮
        let button = UIButton()
        button.setTitle("上一关", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .regular)
        button.addTarget(self, action: #selector(lastLevel), for: .touchUpInside)
        return button
    }()
    let nextLevelButton:UIButton = { // 下一关按钮
        let button = UIButton()
        button.setTitle("下一关", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .regular)
        button.addTarget(self, action: #selector(nextLevel), for: .touchUpInside)
        return button
    }()
    let hero:UIView = { // 玩家视图
        let view = UIImageView()
        view.image = UIImage(named: "human")
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    let box:UIView = { // 箱子视图
        let view = UIImageView()
        view.image = UIImage(named: "box")
        return view
    }()
    let w = UIScreen.main.bounds.width // 屏幕宽
    let h = UIScreen.main.bounds.height // 屏幕高
    let line = 10 // 地图行数（10x10）
    let bgColor = UIColor.gray.withAlphaComponent(0.4)// 背景色
    var itemW = CGFloat(10.0) // 每个单元格尺寸
    var bottonW = CGFloat(45.0) // 方向按钮尺寸
    var heroBeginX:Int = 0 // 玩家初始x下标
    var heroBeginY:Int = 0 // 玩家初始y下标
    var boxBeginX:Int = 0 // 箱子初始x下标
    var boxBeginY:Int = 0 // 箱子初始y下标
    var heroX:Int = 0 // 玩家当前x下标
    var heroY:Int = 0 // 玩家当前y下标
    var boxX:Int = 0 // 箱子当前x下标
    var boxY:Int = 0 // 箱子当前y下标
    var exitX:Int = 0 // 终点x下标
    var exitY:Int = 0 // 终点y下标
    let mapManager = MapManager() // 地图管理器
    var map = [[String]]() // 当前地图
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // 加载UI界面
    func setupUI() {
        itemW = w / CGFloat(Float(line)) // 根据屏幕宽度，计算单个墙视图的平均宽度
        let y = (h - w) / 2.0 - 20 // 地图的y
        map = mapManager.currentMap() // 获取当前地图
        titleLabel.text = "推箱子-第\(mapManager.currentIndex+1)关"
        lastLevelButton.isEnabled = mapManager.currentIndex > 0
        nextLevelButton.isEnabled = mapManager.currentIndex+1 < mapManager.count
        container.frame = CGRect(x: 0, y: y, width: w, height: w)
        view.addSubview(container)
        intPanel()
        initMap(map: map)
        themeColor()
    }
    // 配色
    func themeColor() {
        view.backgroundColor = UIColor.white
        titleLabel.backgroundColor = bgColor
        container.backgroundColor = bgColor
        resetButton.backgroundColor = bgColor
        lastLevelButton.backgroundColor = bgColor
        nextLevelButton.backgroundColor = bgColor
    }
    // 初始化控制面板
    func intPanel () {
        let x = (w - 150) / 2.0 // 标题的x
        let y = (h - w) / 2.0 - 90 // 标题的y
        let halfBW = bottonW / 2.0 // 按钮的一半宽度
        let bX = w / 2.0 // 布局按钮的中心点x
        let bY = ((h - w) / 2.0 - 20) + w + bottonW + halfBW + 10 // 布局按钮的中心点y, 根据container的位置来计算
        // 标题
        titleLabel.frame = CGRect(x: x, y: y, width: 150, height: 50)
        view.addSubview(titleLabel)
        // 向上按钮
        upButton.frame = CGRect(x: bX-halfBW , y: bY-halfBW-bottonW, width: bottonW, height: bottonW)
        view.addSubview(upButton)
        // 向下按钮
        downButton.frame = CGRect(x: bX-halfBW, y: bY+halfBW, width: bottonW, height: bottonW)
        view.addSubview(downButton)
        // 向左按钮
        leftButton.frame = CGRect(x: bX-halfBW-bottonW, y: bY-halfBW, width: bottonW, height: bottonW)
        view.addSubview(leftButton)
        // 向右按钮
        rightButton.frame = CGRect(x: bX+halfBW, y: bY-halfBW, width: bottonW, height: bottonW)
        view.addSubview(rightButton)
        // 重置按钮
        resetButton.frame = CGRect(x: 10, y: bY-halfBW, width: 50, height: 45)
        view.addSubview(resetButton)
        // 上一关 按钮
        lastLevelButton.frame = CGRect(x: w-70, y: bY-bottonW-5, width: 60, height: 40)
        view.addSubview(lastLevelButton)
        // 下一关 按钮
        nextLevelButton.frame = CGRect(x: w-70, y: bY+5, width: 60, height: 40)
        view.addSubview(nextLevelButton)
    }
    // 初始化地图
    func initMap(map: [[String]]) {
        for i in 0..<map.count {
            let array = map[i]
            for j in 0..<array.count {
                let item = array[j]
                if item == " " {
                    continue
                } else if item == "1" {// 添加围墙
                    createWall(xIndex: j, yIndex: i)
                } else if item == "X" || item == "x" { // 添加箱子
                    boxBeginX = j
                    boxBeginY = i
                    updateBoxFrame(xIndex: j, yIndex:i)
                    container.addSubview(box)
                } else if item == "E" || item == "e" { // 添加终点
                    exitX = j
                    exitY = i
                    createExit(xIndex: j, yIndex: i)
                } else if item == "0" { // 添加玩家
                    heroBeginX = j
                    heroBeginY = i
                    updateHeroFrame(xIndex: j, yIndex:i)
                    container.addSubview(hero)
                }
            }
        }
    }
    // 添加围墙
    func createWall (xIndex: Int, yIndex:Int) {
        let wall = UIImageView()
        wall.image = UIImage(named: "wall")
        let x = Double(xIndex) * itemW
        let y = Double(yIndex) * itemW
        wall.frame = CGRect(x: x,y: y,width: itemW,height: itemW)
        container.addSubview(wall)
    }
    // 添加终点
    func createExit (xIndex: Int, yIndex:Int) {
        let label = UILabel()
        label.text = "终点"
        label.textColor = .white
        label.font = .systemFont(ofSize: 10.0, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        label.alpha = 0.7
        let x = Double(xIndex) * itemW
        let y = Double(yIndex) * itemW
        label.frame = CGRect(x: x,y: y,width: itemW,height: itemW)
        container.addSubview(label)
    }
    // 更新玩家的位置
    func updateHeroFrame(xIndex: Int, yIndex:Int) {
        heroX = xIndex
        heroY = yIndex
        let x = Double(xIndex) * itemW
        let y = Double(yIndex) * itemW
        hero.frame = CGRect(x: x,y: y,width: itemW,height: itemW)
    }
    // 更新箱子的位置
    func updateBoxFrame(xIndex: Int, yIndex:Int) {
        boxX = xIndex
        boxY = yIndex
        let x = Double(xIndex) * itemW
        let y = Double(yIndex) * itemW
        box.frame = CGRect(x: x,y: y,width: itemW,height: itemW)
    }
    // 点击方向上
    @objc func upClick() {
        move(direction: .up)
    }
    // 点击方向下
    @objc func downClick() {
        move(direction: .down)
    }
    // 点击方向左
    @objc func leftClick() {
        move(direction: .left)
    }
    // 点击方向右
    @objc func rightClick() {
        move(direction: .right)
    }
    // 重置
    @objc func reset() {
        map[boxY][boxX] = " "
        updateHeroFrame(xIndex: heroBeginX, yIndex: heroBeginY)
        updateBoxFrame(xIndex: boxBeginX, yIndex: boxBeginY)
        map[boxBeginY][boxBeginX] = "X"
    }
    // 上一关
    @objc func lastLevel() {
        if (mapManager.currentIndex <= 0) {
            return
        }
        resetLevel(index: mapManager.currentIndex-1)
    }
    // 下一关
    @objc func nextLevel() {
        if (mapManager.currentIndex >= mapManager.count) {
            return
        }
        resetLevel(index: mapManager.currentIndex+1)
    }
    // 重置为第几关
    func resetLevel(index: Int) {
        for v in view.subviews {
            v.removeFromSuperview()
        }
        for v in container.subviews {
            v.removeFromSuperview()
        }
        mapManager.currentIndex = index
        setupUI()
    }
    // 移动玩家与箱子
    func move(direction: Direction) {
        var x = heroX
        var y = heroY
        var bX = boxX
        var bY = boxY
        switch direction {
        case .up: // 上
            y = heroY-1
            bY = boxY-1
        case .down:// 下
            y = heroY+1
            bY = boxY+1
        case .left:// 左
            x = heroX-1
            bX = boxX-1
        case .right:// 右
            x = heroX+1
            bX = boxX+1
        }
        // 判断是否紧邻箱子，且箱子是否可以推动
        if hasBox(x: x, y: y) && hasWay(x: bX, y: bY) {
            map[boxY][boxX] = " "
            updateBoxFrame(xIndex: bX, yIndex: bY)
            map[bY][bX] = "X"
        }
        // 判断玩家是否有路可走
        if hasWay(x: x, y: y) {
            updateHeroFrame(xIndex: x, yIndex: y)
        }
        // 判断箱子是否到达终点
        if hasEnd() {
            // 弹窗提示
            let alert = UIAlertController(title: nil, message: "太棒啦！通过第\(mapManager.currentIndex+1)关🎉🎉", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确认", style: .default) { [weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.mapManager.currentIndex+1 >= strongSelf.mapManager.count { // 如果已经到最后一关，返回第一关
                    strongSelf.resetLevel(index: 0)
                } else { // 否则，进入下一关
                    strongSelf.nextLevel()
                }
            }
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    // 判断该坐标是否为路
    func hasWay(x: Int, y: Int) -> Bool {
        if x<0 || y<0 || x>=line || y>=line {
            return false
        }
        if map[y][x] == " " || map[y][x] == "E" || map[y][x] == "e" {
          return true
        }
        return false
    }
    // 判断该坐标是否为箱子
    func hasBox(x: Int, y: Int) -> Bool {
        if x<0 || y<0 || x>=line || y>=line {
            return false
        }
        if map[y][x] == "X" || map[y][x] == "x"{
          return true
        }
        return false
    }
    // 判断该坐标是否为终点
    func hasEnd() -> Bool {
        if boxX == exitX && boxY == exitY {
            return true
        }
        return false
    }
}

