companies = ["workeasy1", "workeasy2", "workeasy3", "workeasy4", "workeasy5", "workeasy6", "workeasy7", "workeasy8", "workeasy事務局"]
availabilitities = [1, 1, 1, 1, 1, 1, 1, 1, 0]
hourly_rates = ["12", "15", "21", "7", "10", "18", "05", "24", "88"]
projectmanagers = ["1", "0", "1", "0", "0", "0", "1", "0", "0"]
webdesigners = ["0", "0", "1", "0", "1", "1", "0", "0", "0"]
uiuxdesigners = ["0", "0", "1", "0", "1", "1", "0", "0", "0"]
frontendengineers = ["0", "1", "0", "1", "1", "1", "0", "1", "0"]
backendengineers = ["0", "1", "0", "1", "1", "1", "0", "1", "0"]
0.upto(8) do |idx|
  Detail.create(
    id: idx + 1,
    user_id: idx + 1,
    telephone:  "09012345678",
    birthday:  "19991001",
    company: companies[idx],
    address:  "福岡市中央区天神2町目3",
    languages: "日本語",
    introduction: "こんにちは。",
    availability: availabilitities[idx],
    hourly_rate: hourly_rates[idx],
    projectmanager: projectmanagers[idx],
    webdesigner: webdesigners[idx],
    uiuxdesigner: uiuxdesigners[idx],
    frontendengineer: frontendengineers[idx],
    backendengineer: backendengineers[idx],
    schedule: "15"
  )
end
