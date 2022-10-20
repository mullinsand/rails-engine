module Pagination
  def paginate(collection, results_per_page, page)
    # return collection if 
    if [nil, "", 0].include?(results_per_page)
      results_per_page = 20
    end
    if [nil, "", 0].include?(page)
      page = 1
    end

    total_results = collection.count
    total_pages = total_results/results_per_page.to_i + ((total_results % results_per_page.to_i).zero? ? 0 : 1)
    # check negative
    # check its an integer
    #
    start_point = results_per_page.to_i * (page.to_i - 1)
    collection.offset(start_point).limit(results_per_page)
  end 
end