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

    Podcast.count.should == 1
    target.podcast.sources.sort.should == [target, dupe]
    target.podcast.owners.count.should == 2
  end
end
