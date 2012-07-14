require 'spec_helper'

describe GamePencil::MultidimensionalArray do

  its([0]) { should be_nil }
  its([0, 0]) { should be_nil }

  context do

    example do
      subject[0, 0] = true
      subject[0, 0].should be_true
    end
  end

  context do

    subject { described_class.new([%w[a b], %w[c d]]) }

    its([0, 0]) { should == 'a' }
    its([0, 1]) { should == 'b' }
    its([1, 0]) { should == 'c' }
    its([1, 1]) { should == 'd' }
  end
end
