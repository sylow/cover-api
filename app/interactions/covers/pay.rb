module Covers
  class Pay < ActiveInteraction::Base
    object :user
    integer :id

    def execute
      cover = find_cover

      return nil unless process_payment(cover)
      return nil unless process_to_run(cover)   # as soon as we pay we need to run

      cover
    end

    private
    # Method to find the cover and handle the "not found" error
    def find_cover
      cover = user.covers.find_by(id: id)
      unless cover
        errors.add(:cover, 'not found')
        return nil
      end
      cover
    end

    # Method to handle the payment process and its validations
    def process_payment(cover)
      if cover&.aasm_state == 'created' && cover.may_pay?
        cover.pay!
      else
        errors.add(:credit, 'is not enough') unless cover.may_pay?
        return false
      end
      true
    end

    # Method to handle the payment process and its validations
    def process_to_run(cover)
      if cover&.aasm_state == 'paid' && cover.may_run?
        cover.run!
      else
        errors.add(:cover, 'is not running') unless cover.may_run?
        return false
      end
      true
    end
  end
end
