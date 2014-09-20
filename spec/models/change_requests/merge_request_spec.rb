require 'spec_helper'

describe ChangeRequests::MergeRequest do
  specify do
    target = Fabricate :source

    target.opml_files << Fabricate(:opml_file)
    dupe = Fabricate :source, podcast: Fabricate(:podcast, title: 'something else')
    dupe.opml_files << Fabricate(:opml_file)

    cr = ChangeRequests::MergeRequest.new owner_id: Owner.first.id
    cr.prefill source_id: dupe.id, target_id: target.id
    cr.save
    cr.apply!

    # Idempotent
    Podcast.first.merge(Podcast.first)

    expect(Podcast.count).to be ==  1
    expect(target.podcast.sources.sort).to eql [target, dupe]
    expect(target.podcast.owners.count).to eql 2
    expect(Podcast.first.subscriber_count).to be == 2


  end
end
