//
//  main.swift
//  属性
//
//  Created by swift on 2022/2/8.
//

import Foundation

print("Hello, World!")


class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            self.totalSteps += 10
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 20


struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
//            let centerX = origin.x + (size.width / 2)
//            let centerY = origin.y + (size.height / 2)
//            return Point(x: centerX, y: centerY)
            // 简化的写法： 隐式返回
            Point(x: origin.x + (size.width / 2),
                              y: origin.y + (size.height / 2))
        }
//        set(newCenter) {
//            origin.x = newCenter.x - size.width/2
//            origin.y = newCenter.y - size.height/2
//        }
        // 也可以使用默认的名称 newValue
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15, y: 15)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")


print("~~~~~~~~~~~ 只读 ~~~~~~~~~~~")
// 只读计算属性
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}

let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
// fourByFiveByTwo.volume = 50  // Cannot assign to property: 'volume' is a get-only property


class Person {
    var age = 1
    var sex = 1
    var isGotoSchool: Bool {
        if age > 7 {
            return true
        } else {
            return false
        }
    }
}
// 属性包装器
@propertyWrapper
struct MaxScore {
    private var number = 0
    var wrappedValue : Int {
        get { return number }
        set { number = min(newValue, 100)}
    }
}

class Student: Person {
    
    @MaxScore var score: Int
    
    // _mathScore 和 mathScore 是不同的属性
    private var _mathScore = MaxScore()
    var mathScore: Int {
        get { return _mathScore.wrappedValue }
        set { _mathScore.wrappedValue = newValue }
    }
    
    var height: Double = 150
    
    
    var weight: Double = 90
    // 自定义存储属性 添加属性观察器
    var tipStr = "" {
        willSet{
            print("tipStr will set \(newValue)")
        }
        didSet {
            print("tipStr did set \(tipStr)")
        }
    }
    // 内部可读可写，外部只读
    private(set) var name = "Lucy" {
        willSet{
            print("name old value is \(name)")
            print("name will set \(newValue)")
        }
        didSet {
            print("name did set \(name)")
        }
    }
    
    var isHealth : Bool {
        
        let result = weight*10000/(height*height)
        if sex == 1 {
            switch result {
            case 19 ..< 24:
                tipStr = "我好羡慕你啊,你这可是魔鬼身材啊!! :))"
                return false

            case 24 ..< 29:
                tipStr = "哎哟，小仙女，有点重哦！"
                return true
                
            case 29 ..< 34:
                tipStr = "哎呀，小仙女，你是胖妹妹哟，多做做运动拉"
                return false
                
            case let x where x >= 34 :
                tipStr = "哇，这位小仙女，你非常胖拉，要多多运动啊!:)"
                return false
           
            default:
                tipStr = "瘦了一点点，你应该多吃点东西啊!"
                return false
            }
            
        } else {
            switch result {
            case 19 ..< 24:
                tipStr = "我好羡慕你啊,你这可是魔鬼身材啊!! :))"
                return false

            case 24 ..< 29:
                tipStr = "哎哟，小仙女，有点重哦！"
                return true
                
            case 29 ..< 34:
                tipStr = "哎呀，小仙女，你是胖妹妹哟，多做做运动拉"
                return false
                
            case let x where x >= 34 :
                tipStr = "哇，这位小仙女，你非常胖拉，要多多运动啊!:)"
                return false
           
            default:
                tipStr = "瘦了一点点，你应该多吃点东西啊!"
                return false
            }
            
        }
        
    }
    
    init(height h: Double, weight w : Double) {
        height = h
        weight = w
        // isHealth = true // Cannot assign to property: 'isHealth' is a get-only property
    }
    func changeName(newName: String) {
        name = newName
    }
    func printPointer() {
        
        withUnsafePointer(to: &mathScore) { ptr in
            print("mathScore pointer is \(ptr)")
        }
        
        withUnsafePointer(to: &_mathScore) { ptr in
            print("_mathScore pointer is \(ptr)")
        }
    }
}
let student1 = Student(height: 164, weight: 49.5)
if student1.isHealth {
    
} else {
    
}
print(student1.tipStr)
print("name is \(student1.name)")
//student1.name = "Lala"

student1 .changeName(newName: "Luna")
student1.score = 50
print(student1.score)  // 50

student1.score = 150
print(student1.score)  // 100


student1.mathScore = 120
print(student1.mathScore)  // 100

student1.printPointer()


@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int
    
    private(set) var projectedValue: Bool
    
    var wrappedValue: Int {
        get { return number }
//        set { number = min(newValue, maximum)}
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
    
    init() {
        maximum = 12
        number = 0
        self.projectedValue = false
    }
    
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
        self.projectedValue = false
    }
    
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
        self.projectedValue = false
    }
}

struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}

var zeroRectangle = ZeroRectangle()
print(zeroRectangle.height, zeroRectangle.width)

struct UnitRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}

var unitRectangle = UnitRectangle()
unitRectangle.height = 15
print(unitRectangle.height, unitRectangle.width)

struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 6) var width: Int
    
}

var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)

narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)


struct SomeStructure {
    @SmallNumber var someNumber: Int
}
var someStruct = SomeStructure()

someStruct.someNumber = 4
print(someStruct.$someNumber)


