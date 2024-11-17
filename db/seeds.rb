User.create({
  email: 'admin@example.com', password: '12345678'
})
Package.create([
  { name: 'Try Out', credits: 1, price_cents: 200,
    description: 'Test our cover letter service with one credit to generate a single tailored cover letter.',
    stripe_id: 'test_4gwg2O2Y17MR17abIM'
  },
  { name: "Pro Pack", credits: 25, price_cents: 2000,
    description: 'Create 25 customized cover letters for a variety of job applications and industries.',
    stripe_id: 'test_4gwg2O2Y17MR17abIM'
  },
  { name: "Career Booster", credits: 50, price_cents: 3500,
    description: 'Supercharge your job search with 50 credits to generate cover letters for numerous opportunities.',
    stripe_id: 'test_4gwg2O2Y17MR17abIM'
  },
  {
    name: "Email Verification", credits: 1, price_cents: 0,
    description: 'Free credit when you verify your email address.',
    stripe_id: '----'
  },
])