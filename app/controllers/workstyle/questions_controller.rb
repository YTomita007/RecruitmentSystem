class Workstyle::QuestionsController < ApplicationController
  before_action :fruits_character_set, only: [:result]

  def step1
    @percent = 1
  end

  def step2
    @percent = 2
  end

  def step3
    @percent = 3
  end

  def step4
    @percent = 4
  end

  def step5
    @percent = 5
  end

  def step6
    @percent = 6
  end

  def step7
    @percent = 7
  end

  def step8
    @percent = 8
  end

  def step9
    @percent = 9
  end

  def birth
    @percent = 10
  end

  def result
    @user = User.new
    @user.build_detail
  end

  private

  def fruits_character_set
    fnum = 0
    if (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 0
      x1 = 54 + (params[:birthday]["birthday(1i)"].to_i - 1920) / 4 * 21
      x2 = 25 + (params[:birthday]["birthday(1i)"].to_i - 1920) / 4 * 21
      x3 = x1
      x4 = x2
      x5 = x3 + 1
      x6 = x4 + 1
      x7 = x5 + 1
      x8 = x6 + 1
      x9 = x7 + 2
      x10 = x8 + 1
      x11 = x9 + 1
      x12 = x10 + 1

    elsif (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 1
      x1 = 0 + (params[:birthday]["birthday(1i)"].to_i - 1921) / 4 * 21
      x2 = 31 + (params[:birthday]["birthday(1i)"].to_i - 1921) / 4 * 21
      x3 = x1 - 1
      x4 = x2 - 1
      x5 = x3 + 1
      x6 = x4 + 1
      x7 = x5 + 1
      x8 = x6 + 1
      x9 = x7 + 2
      x10 = x8 + 1
      x11 = x9 + 1
      x12 = x10 + 1

    elsif (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 2
      x1 = 5 + (params[:birthday]["birthday(1i)"].to_i - 1922) / 4 * 21
      x2 = 36 + (params[:birthday]["birthday(1i)"].to_i - 1922) / 4 * 21
      x3 = x1 - 1
      x4 = x2 - 1
      x5 = x3 + 1
      x6 = x4 + 1
      x7 = x5 + 1
      x8 = x6 + 1
      x9 = x7 + 2
      x10 = x8 + 1
      x11 = x9 + 1
      x12 = x10 + 1

    elsif (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 3
      x1 = 10 + (params[:birthday]["birthday(1i)"].to_i - 1923) / 4 * 21
      x2 = 41 + (params[:birthday]["birthday(1i)"].to_i - 1923) / 4 * 21
      x3 = x1 - 1
      x4 = x2 - 1
      x5 = x3 + 1
      x6 = x4 + 1
      x7 = x5 + 1
      x8 = x6 + 1
      x9 = x7 + 2
      x10 = x8 + 1
      x11 = x9 + 1
      x12 = x10 + 1
    end

    if params[:birthday]["birthday(2i)"] == "1"
      fnum = x1
    elsif params[:birthday]["birthday(2i)"] == "2"
      fnum = x2
    elsif params[:birthday]["birthday(2i)"] == "3"
      fnum = x3
    elsif params[:birthday]["birthday(2i)"] == "4"
      fnum = x4
    elsif params[:birthday]["birthday(2i)"] == "5"
      fnum = x5
    elsif params[:birthday]["birthday(2i)"] == "6"
      fnum = x6
    elsif params[:birthday]["birthday(2i)"] == "7"
      fnum = x7
    elsif params[:birthday]["birthday(2i)"] == "8"
      fnum = x8
    elsif params[:birthday]["birthday(2i)"] == "9"
      fnum = x9
    elsif params[:birthday]["birthday(2i)"] == "10"
      fnum = x10
    elsif params[:birthday]["birthday(2i)"] == "11"
      fnum = x11
    elsif params[:birthday]["birthday(2i)"] == "12"
      fnum = x12
    end

    fnum = fnum + params[:birthday]["birthday(3i)"].to_i
    while fnum >= 60 do
      fnum = fnum - 60
    end

    while fnum < 0 do
      fnum = fnum + 60
    end

    if fnum == 0
      @character = nil
    elsif fnum == 3 || fnum == 9 || fnum == 15 || fnum == 34 || fnum == 40 || fnum == 46
      @character = Fruit.find(7)
    elsif fnum == 4 || fnum == 10 || fnum == 16 || fnum == 33 || fnum == 39 || fnum == 45
      @character = Fruit.find(8)
    elsif fnum == 13 || fnum == 19 || fnum == 24 || fnum == 25 || fnum == 30 || fnum == 36
      @character = Fruit.find(5)
    elsif fnum == 6 || fnum == 43 || fnum == 49 || fnum == 54 || fnum == 55 || fnum == 60
      @character = Fruit.find(6)
    elsif fnum == 1 || fnum == 7 || fnum == 42 || fnum == 48
      @character = Fruit.find(4)
    elsif fnum == 51 || fnum == 52 || fnum == 57 || fnum == 58
      @character = Fruit.find(2)
    elsif fnum == 12 || fnum == 18 || fnum == 31 || fnum == 37
      @character = Fruit.find(1)
    elsif fnum == 21 || fnum == 22 || fnum == 27 || fnum == 28
      @character = Fruit.find(3)
    elsif fnum == 14 || fnum == 20 || fnum == 23 || fnum == 26 || fnum == 29 || fnum == 35
      @character = Fruit.find(11)
    elsif fnum == 5 || fnum == 44 || fnum == 50 || fnum == 53 || fnum == 56 || fnum == 59
      @character = Fruit.find(12)
    elsif fnum == 2 || fnum == 8 || fnum == 41 || fnum == 47
      @character = Fruit.find(10)
    elsif fnum == 11 || fnum == 17 || fnum == 32 || fnum == 38
      @character = Fruit.find(9)
    end
  end
end
