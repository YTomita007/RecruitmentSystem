emails = %w(aa@example.com bb@example.com cc@example.com dd@example.com ee@example.com ff@example.com gg@example.com hh@example.com admin@example.com)
lastnames = ["酸化水素水", "二酸化炭素", "クエン酸", "カルボン酸", "テストユーザ", "テストユーザ", "テストユーザ", "テストユーザ", "work管理者"]
firstnames = ["必要", "不要", "必要", "必要", "01", "02", "03", "04", "easy"]
roles = ["2", "2", "1", "2", "2", "2", "2", "2", "1"]
administrators = ["0", "0", "0", "0", "0", "0", "0", "0", "1"]
detail_ids = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
0.upto(8) do |idx|
  User.create(
    id: idx + 1,
    email: emails[idx],
    password: "12345678",
    lastname: lastnames[idx],
    firstname: firstnames[idx],
    administrator: administrators[idx],
    role: roles[idx]
  )
end
