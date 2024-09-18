module Covers
  class Generate < ActiveInteraction::Base
    object :cover

    def execute
      if cover.cover.present?
        errors.add(:user, "Cover letter already generated")
        return
      end

      if user.credits < 1
        errors.add(:user, "Insufficient credits")
        return
      end

      ApplicationRecord.transaction do
        output = ChatGpt::GenerateCoverLetter.run(cover: cover)
        cover.update!(cover: output.response.response["choices"][0]["message"]["content"]["cover"])
      end

      cover
    end

    private
    def user
      @user ||= cover.user
    end
  end
end
