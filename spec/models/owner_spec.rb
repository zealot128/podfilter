require 'spec_helper'

describe Owner do
  it 'creates owner with random token and image' do
    owner = Owner.create
    owner = Owner.find(owner)
    expect(owner.token).to be_present
    expect(owner.image).to be_present
  end
end
