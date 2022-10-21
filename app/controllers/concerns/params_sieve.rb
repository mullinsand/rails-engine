module ParamsSieve
  def params_present?(param1, param2=nil)
    ![nil, ""].include?(param1) || ![nil, ""].include?(param2)
  end

  def min_greater_than_max?
    return false if params[:min_price].nil? || params[:max_price].nil?

    params[:min_price].to_i > params[:max_price].to_i
  end

  def name_and_price
    return name_and_price_error if params[:name] && (params[:min_price] || params[:max_price])
  end

  def negative_prices?
    Item.negative_prices?(params[:min_price], params[:max_price])
  end
end