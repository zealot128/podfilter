require 'spec_helper'

describe SimilarityCalculation do
  let(:owner1) { Owner.new }
  let(:owner2) { Owner.new }
  let(:owner3) { Owner.new }
  let(:service){ SimilarityCalculation.new(owner1) }

  specify 'nothing in common' do
    expect(service).to receive(:podcast_ids).with(owner1).and_return(list: [], ignore: [])
    expect(service.distance(list: [], ignore: [])).to eq 0
  end

  specify 'something in common' do
    owner1.save
    owner2.save

    expect(service).to receive(:podcast_ids).with(owner1).and_return(list: [1,2], ignore: [])
    expect(service).to receive(:podcast_ids).with(owner2).and_return(list: [1,3], ignore: [])

    expect(service.distance(list: [1,3], ignore: [])).to be 1

    # Podcast ID 3 with weight 1 recommended
    expect(service.recommendations).to eq [ [3, 1] ]
  end

  specify 'more users' do
    owner1.save
    owner2.save
    owner3.save

    expect(service).to receive(:podcast_ids).with(owner1).and_return(list: [1,2 ,3],  ignore: [])
    expect(service).to receive(:podcast_ids).with(owner2).and_return(list: [1,10,20], ignore: [])
    expect(service).to receive(:podcast_ids).with(owner3).and_return(list: [2,20,30], ignore: [])

    # o1 hat mit o2 und o3 jeweils einen podcast gemeinsam ( 1 und 2). o2 und o3 bieten podcast 10, 20 und 30, 20 sollte zuerst stehen

    expect(service.recommendations).to eq [ [20, 2], [30, 1], [10, 1] ]
  end

  specify 'ignore is negative', focus: true do
    listens owner1, list: [1], ignore: [3]
    listens owner2, list: [1,3,4]
    listens owner3, list: [1,5]

    expect(service.recommendations(top_k: 1)).to eq [ [5, 1] ]
  end

  def listens(owner, list: [], ignore: [])
    owner.save
    expect(service).to receive(:podcast_ids).with(owner).and_return(list: list,  ignore: ignore)
  end

end
