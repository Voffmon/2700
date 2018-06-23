# Create users
User.create!([
  {email: "michael.gassner@exsops.com", role: "admin", state: "approved", name: "Michael", password: "vlDJh0JsAp", password_confirmation: "vlDJh0JsAp", confirmed_at: DateTime.now},
  {email: "sebastian.poell@gmail.com", role: "admin", state: "approved", name: "Sebastian", password: "NsjStUOeYq", password_confirmation: "NsjStUOeYq", confirmed_at: DateTime.now},
  {email: "alexpoell@gmail.com", role: "admin", state: "approved", name: "Alex", password: "oPvHHXpcmb", password_confirmation: "oPvHHXpcmb", confirmed_at: DateTime.now},
  {email: "alexpoell@infound.at", role: "admin", state: "approved", name: "Alex", password: "oPvHHXpcmb", password_confirmation: "oPvHHXpcmb", confirmed_at: DateTime.now},
  {email: "gregor.anreiter@gmail.com", role: "admin", state: "approved", name: "Gregor", password: "HN3qq1XPcs", password_confirmation: "HN3qq1XPcs", confirmed_at: DateTime.now},
  {email: "gregor.anreiter@infound.at", role: "admin", state: "approved", name: "Gregor", password: "HN3qq1XPcs", password_confirmation: "HN3qq1XPcs", confirmed_at: DateTime.now},
])
