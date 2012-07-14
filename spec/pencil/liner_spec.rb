require 'spec_helper'

describe GamePencil::Pencil::Liner do

  subject { Object.new.tap { |o| o.extend described_class } }

  describe "#trace_line" do

    context "when draw a straight line." do

      it "draw a straight line 0 to 5." do
        subject.trace_line(0, 5).to_a.should == [0, 1, 2, 3, 4]
      end

      it "draw a straight line 0 to -5." do
        subject.trace_line(0, -5).to_a.should == [0, -1, -2, -3, -4]
      end

      it "draw a straight line -5 to 0." do
        subject.trace_line(-5, 0).to_a.should == [-5, -4, -3, -2, -1]
      end

      it "draw a straight line -5 to -10." do
        subject.trace_line(-5, -10).to_a.should == [-5, -6, -7, -8, -9]
      end

      it "draw a straight line 5 to 0." do
        subject.trace_line(5, 0).to_a.should == [5, 4, 3, 2, 1]
      end

      it "draw a straight line 5 to 10." do
        subject.trace_line(5, 10).to_a.should == [5, 6, 7, 8, 9]
      end
    end

    context "when drawing a straght line in ND." do

      it "trace a line (0) to (3)." do
        subject.trace_line([0], [3]).to_a.should == [0, 1, 2]
      end

      it "trace a line (0,0) to (3,3)." do
        subject.trace_line([0, 0], [3, 3]).to_a.should == [[0, 0], [1, 1], [2, 2]]
      end

      it "trace a line (0,0,0) to (3,3,3)." do
        subject.trace_line([0, 0, 0], [3, 3, 3]).to_a.should == [[0, 0, 0], [1, 1, 1], [2, 2, 2]]
      end
    end

    context "when drawing a slant line of 2D." do
      subject { GamePencil::Pencil.trace_line([0, 0], [6, 3]).to_a }
      its(:first) { should == [0, 0] }
      it { should include [2, 1] }
      it { should include [4, 2] }
      its(:last) { should == [5, 2] }
      its(:count) { should == 6 }
    end

    context "when drawing a slant line of 3D." do
      subject { GamePencil::Pencil.trace_line([0, 0, 0], [12, 6, 3]).to_a }

      its(:first) { should == [0, 0, 0] }
      it { should include [4, 2, 1] }
      it { should include [8, 4, 2] }
      its(:last) { should == [11, 5, 2] }
      its(:count) { should == 12 }
    end
  end
end
