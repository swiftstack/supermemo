import Test

@testable import SuperMemo

test.case("EasinessFactor") {
    let factor = SuperMemo2.EasinessFactor(1.5)
    expect(factor.value == 1.5)

    let min = SuperMemo2.EasinessFactor(1.2)
    expect(min.value == 1.3)

    let max = SuperMemo2.EasinessFactor(2.6)
    expect(max.value == 2.5)
}

test.case("Repetition") {
    var repetition = SuperMemo2.Repetition.initial
    expect(repetition.number == 0)
    expect(repetition.interval == 0)

    repetition.next(forFactor: 0)

    expect(repetition.number == 1)
    expect(repetition.interval == 1)

    repetition.next(forFactor: 0)

    expect(repetition.number == 2)
    expect(repetition.interval == 6)

    repetition.next(forFactor: 0)

    expect(repetition.number == 3)
    expect(repetition.interval == 8)
}

test.case("Item") {
    var item = SuperMemo2.Item()
    var repetition = SuperMemo2.Repetition.initial
    expect(item.factor == 2.5)
    expect(item.repetition == repetition)

    item.apply(response: .difficult)
    repetition.next(forFactor: item.factor)
    expect(item.factor == 1.3)
    expect(item.repetition == repetition)

    item.apply(response: .perfect)
    repetition.next(forFactor: item.factor)
    expect(Int(item.factor.value * 10) == 14)
    expect(item.repetition == repetition)

    item.apply(response: .perfect)
    repetition.next(forFactor: item.factor)
    expect(Int(item.factor.value * 10) == 15)
    expect(item.repetition == repetition)

    item.apply(response: .blackout)
    repetition = .initial
    expect(Int(item.factor.value * 10) == 15)
    expect(item.repetition == repetition)
}

test.run()
