class Question < ApplicationRecord
  include ActiveModel::Model

  attr_accessor :step1, :step2, :step3, :step4, :step5, :step6, :step7

  class << self
    def step1
      @step1
    end

    def step2
      @step2
    end

    def step3
      @step3
    end

    def step4
      @step4
    end

    def step5
      @step5
    end

    def step6
      @step6
    end

    def step7
      @step7
    end
  end
end
