User.create({
  email: 'admin@example.com', password: '12345678'
})

Package.create([
  { name: 'Once',           credits: 1,  price_cents: 50 },
  { name: "Starter Pack",   credits: 10, price_cents: 399 },
  { name: "Pro Pack",       credits: 20, price_cents: 699 },
  { name: "Career Booster", credits: 50, price_cents: 1299 }
])
