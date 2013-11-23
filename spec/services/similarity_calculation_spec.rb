require 'spec_helper'

describe SimilarityCalculation do
  let(:owner1) { Owner.new }
  let(:owner2) { Owner.new }
  let(:service){ SimilarityCalculation.new(owner1) }

  specify 'nothing in common' do
    expect_any_instance_of(SimilarityCalculation).to receive(:my_podcasts).and_return([])
    expect(service.distance([])).to eq 0
  end

  specify 'something in common' do
    owner1.save
    owner2.save

    expect_any_instance_of(SimilarityCalculation).to receive(:my_podcasts).at_least(1).and_return([1,2])
    expect(service).to receive(:podcast_ids).with(owner2).and_return([1,3])

    expect(service.distance([1,3])).to be 1

    # Podcast ID 3 with weight 1 recommended
    expect(service.recommendations).to eq [ [3, 1] ]
  end

  specify 'more users' do
    owner1.save
    owner2.save
    owner3 = Owner.create
    expect_any_instance_of(SimilarityCalculation).to receive(:my_podcasts).at_least(1).and_return([1,2,3])

    expect(service).to receive(:podcast_ids).with(owner2).and_return([1,10,20])
    expect(service).to receive(:podcast_ids).with(owner3).and_return([2,20,30])

    # o1 hat mit o2 und o3 jeweils einen podcast gemeinsam ( 1 und 2). o2 und o3 bieten podcast 10, 20 und 30, 20 sollte zuerst stehen

    expect(service.recommendations).to eq [ [20, 2], [30, 1], [10, 1] ]
  end
end
