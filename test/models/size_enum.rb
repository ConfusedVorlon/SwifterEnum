class SizeEnum < SwifterEnum::Base
  set_values [:big, :small]

  def height_ft
    case @value
    when :big
      8
    when :small
      5
    end
  end
end
