numbers = %w(1 1 1 2 2 3 3 3)
classifications = ["ウェブ", "ウェブ", "ウェブ", "アプリ", "アプリ", "その他", "その他", "その他"]
titles = ["CMS", "ウェブサイト/LP", "ウェブサービス", "iPhone", "アンドロイド", "ゲーム", "ソフトウェア", "アウトソーシング"]
descriptions = ["webの専門的な知識がなくても、運用管理を行えるシステム（例：ワードプレス）", "情報提供を目的としたサイト（ページ閲覧のみ）", "サービス提供を目的としたサイト（例：ホテルの予約、商品購入）", "アップル社が開発した端末（OS）へ導入するアプリケーション", "Google社が開発した端末（OS）へ導入するアプリケーション", "ウェブブラウザで遊べるコンピュータゲーム", "コンピューターを動かすためのプログラム", "外注先としてworkeasyのチームを利用する"]
0.upto(7) do |idx|
  Category.create(
    id: idx + 1,
    number: numbers[idx],
    classification: classifications[idx],
    title: titles[idx],
    description: descriptions[idx]
  )
end
