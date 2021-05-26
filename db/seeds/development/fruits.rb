enames = ["apple", "peach", "watermelon", "strawberry", "melon", "grape", "pear", "kiwifruit", "mango", "orange", "bananas", "pineapple"]
wnames = ["りんご", "桃", "スイカ", "いちご", "メロン", "ぶどう", "梨", "キウイ", "マンゴー", "みかん", "バナナ", "パイナップル"]
animals = ["ゾウ", "ライオン", "ペガサス", "チーター", "オオカミ", "トラ", "サル", "コアラ", "コジカ", "タヌキ", "ヒツジ", "クロヒョウ"]
groups = ["太陽", "太陽", "太陽", "太陽", "地球", "地球", "地球", "地球", "新月", "新月", "満月", "満月"]
0.upto(11) do |idx|
  Fruit.create(
    id: idx + 1,
    ename: enames[idx],
    wname: wnames[idx],
    animal: animals[idx],
    group: groups[idx],
    cabbala: idx + 1,
    description: "詳細を追記してください。"
  )
end
