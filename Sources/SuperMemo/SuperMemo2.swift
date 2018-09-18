// https://www.supermemo.com/english/ol/sm2.htm

public enum SuperMemo2 {
    public struct Item {
        public private(set) var factor: EasinessFactor
        public private(set) var repetition: Repetition

        public init(
            factor: EasinessFactor = 2.5,
            repetition: Repetition = .initial)
        {
            self.factor = factor
            self.repetition = repetition
        }

        public mutating func apply(response: Response) {
            // If the quality response was lower than 3 then start repetitions
            // for the item from the beginning without changing the E-Factor
            // (i.e. use intervals I(1), I(2) etc.
            // as if the item was memorized anew).
            guard response.isAссeptable else {
                self.repetition = .initial
                return
            }
            factor.apply(response: response)
            repetition.next(forFactor: factor)
        }
    }

    public struct EasinessFactor: Equatable {
        public private(set) var value: Double

        public static let min: Double = 1.3
        public static let max: Double = 2.5

        public init(_ value: Double) {
            self.value = clamp(value, EasinessFactor.min, EasinessFactor.max)
        }

        // After each repetition modify the E-Factor of
        // the recently repeated item according to the formula:
        public mutating func apply(response: Response) {
            let factor = (5 - Double(response.rawValue))
            let value = self.value + (0.1 - factor * (0.8 + factor * 0.2))
            self.value = clamp(value, EasinessFactor.min, EasinessFactor.max)
        }

        public func applying(response: Response) -> EasinessFactor {
            var factor = self
            factor.apply(response: response)
            return factor
        }
    }

    public struct Repetition: Equatable {
        public var number: Int
        public var interval: Int

        public static let initial: Repetition = .init(number: 0, interval: 0)

        // Repeat items using the following intervals:
        // I(1):=1
        // I(2):=6
        // for n>2: I(n):=I(n-1)*EF
        mutating func next(forFactor factor: EasinessFactor) {
            switch number {
            case 0: interval =  1
            case 1: interval = 6
            default:
                let value = (Double(interval) * factor.value)
                interval = Int(value.rounded(.toNearestOrAwayFromZero))
            }
            number += 1
        }
    }

    // 5 - perfect response
    // 4 - correct response after a hesitation
    // 3 - correct response recalled with serious difficulty
    // 2 - incorrect response; where the correct one seemed easy to recall
    // 1 - incorrect response; the correct one remembered
    // 0 - complete blackout.
    public enum Response: Int, CustomStringConvertible {
        case blackout
        case incorrect
        case mistake
        case difficult
        case hesitation
        case perfect

        var isAссeptable: Bool {
            return self.rawValue >= 3
        }

        public var description: String {
            switch self {
            case .perfect:
                return "perfect response"
            case .hesitation:
                return "correct response after a hesitation"
            case .difficult:
                return "correct response recalled with serious difficulty"
            case .mistake:
                return "incorrect response; " +
                       "where the correct one seemed easy to recall"
            case .incorrect:
                return "incorrect response; the correct one remembered"
            case .blackout:
                return "complete blackout"
            }
        }
    }
}

extension SuperMemo2.EasinessFactor
: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(Double(value))
    }

    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

// MARK: clamp

@inline(__always)
func clamp<T : Comparable>(_ value: T, _ lower: T, _ upper: T) -> T {
    return max(lower, min(value, upper))
}
