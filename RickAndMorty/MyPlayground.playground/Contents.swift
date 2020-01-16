import UIKit

DispatchQueue.global(qos: .background).sync {
    for i in 0 ... 5 {
        print("(background) \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0 ... 5 {
        print("(ui) \(i)")
    }
}

let celcius = [-5.0, 10.0, 21.0, 33.0, 50.0]
var fahrenheit: [Double] = celcius.map { $0 * (9.0 / 5.0) + 32 }
print(celcius)
print(fahrenheit)

let values = [7.0, 3.0, 10.0]
let avg: Double = values.reduce(0.0) { $0 + $1 / Double(values.count) }
print(avg)

let arr = [11, 13, 14, 17, 21, 23, 33, 22]
let even = arr.filter { $0 % 2 == 0 }
print(even)
