class GenerateCoverJob < ApplicationJob
  # include Sidekiq::Job
  queue_as :default

  def perform(cover_id)
    cover = Cover.find(cover_id)

    # Run your logic for generating the cover
    Covers::Generate.run(cover: cover)

  end
end
