class AdminController < ApplicationController
  http_basic_authenticate_with name: ENV['SIDEKIQ_WEB_USER'], password: ENV['SIDEKIQ_WEB_PASSWORD']

  def duplicates
    @duplicates = DuplicateCandidate.limit(20)
  end

  def merge
    @duplicate = DuplicateCandidate.find(params[:id])

    binding.pry
  end
end
