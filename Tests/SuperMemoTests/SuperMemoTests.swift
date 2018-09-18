import Test
@testable import SuperMemo

final class SuperMemoTests: TestCase {
    func testEasinessFactor() {
        let factor = SuperMemo2.EasinessFactor(1.5)
        assertEqual(factor.value, 1.5)

        let min = SuperMemo2.EasinessFactor(1.2)
        assertEqual(min.value, 1.3)

        let max = SuperMemo2.EasinessFactor(2.6)
        assertEqual(max.value, 2.5)
    }

    func testRepetition() {
        var repetition = SuperMemo2.Repetition.initial
        assertEqual(repetition.number, 0)
        assertEqual(repetition.interval, 0)

        repetition.next(forFactor: 0)

        assertEqual(repetition.number, 1)
        assertEqual(repetition.interval, 1)

        repetition.next(forFactor: 0)

        assertEqual(repetition.number, 2)
        assertEqual(repetition.interval, 6)

        repetition.next(forFactor: 0)

        assertEqual(repetition.number, 3)
        assertEqual(repetition.interval, 8)
    }

    func testItem() {
        var item = SuperMemo2.Item()
        var repetition = SuperMemo2.Repetition.initial
        assertEqual(item.factor, 2.5)
        assertEqual(item.repetition, repetition)

        item.apply(response: .difficult)
        repetition.next(forFactor: item.factor)
        assertEqual(item.factor, 1.3)
        assertEqual(item.repetition, repetition)

        item.apply(response: .perfect)
        repetition.next(forFactor: item.factor)
        assertEqual(Int(item.factor.value * 10), 14)
        assertEqual(item.repetition, repetition)

        item.apply(response: .perfect)
        repetition.next(forFactor: item.factor)
        assertEqual(Int(item.factor.value * 10), 15)
        assertEqual(item.repetition, repetition)

        item.apply(response: .blackout)
        repetition = .initial
        assertEqual(Int(item.factor.value * 10), 15)
        assertEqual(item.repetition, repetition)
    }
}
