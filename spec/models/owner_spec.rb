require 'spec_helper'

describe Owner do
  it 'creates owner with random token and image' do
    owner = Owner.create
    owner = Owner.find(owner)
    owner.token.should be_present
    owner.image.should be_present
  end
end
