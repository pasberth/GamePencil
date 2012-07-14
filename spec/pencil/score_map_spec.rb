require 'spec_helper'

describe GamePencil::Pencil::ScoreMap do

  context "when any arguments are not given" do
    
    let(:score_map) { described_class.new }
    subject { score_map }
    
    describe "#cost_map" do

      it "equates omission of a block with a empty list." do
        subject.cost_map(0, 0).should be_nil
      end

      context "when initializing with a block of the constructor." do
        let :map do
          [ 1, 2 ]
        end

        subject { described_class.new { |x| map[x] } }

        it "calls the block." do
          subject.cost_map(0).should == 1
        end
      end
    end

    describe "#begin_point" do

      it "raises a error because not initialized" do
        expect { subject.begin_point }.should raise_error ArgumentError
      end
    end

    describe "#movement_point" do

      it "raises a error because not initialized." do
        expect { subject.movement_points }.should raise_error ArgumentError
      end
    end

    describe "#score_max" do

      its(:score_max) { should == Float::INFINITY }
    end
  end

  describe "#begin" do

    let :score_map do
      described_class.new {1}
    end

    subject { score_map.begin(5, 5) }
    
    it { should be_instance_of GamePencil::Pencil::ScoreMap }
    its(:begin_point) { should == [5, 5] }
  end

  describe "#limit_score" do

    let :score_map do
      described_class.new {1}
    end

    subject { score_map.limit_score(5) }

    it { should be_instance_of GamePencil::Pencil::ScoreMap }
    its(:score_max) { should == 5 }
  end

  describe "#each" do
    let :map do
      [ [1, 2],
        [2, 3] ]
    end

    let :score_map do
      described_class.new { |x, y| map[x] && map[x][y] or nil }.
        movement([1, 0], [0, 1], [-1, 0], [0, -1])
    end

    context "when not specified, excluding starting point." do

      subject { score_map.begin(0, 0).each.to_a }

      [ [[[0, 0], 1]],
        #
        # The root model array. ## "(x,y) score".
        #
        # (0,0) 1   (0,1) 8
        #   v         
        # (1,0) 3   (1,1) 6
        [[[0, 0], 1], [[1, 0], 3]],
        #
        # (0,0) 1 > (0,1) 3
        #              
        # (1,0) 8   (1,1) 6
        [[[0, 0], 1], [[0, 1], 3]],
        #
        # These will have collected into the one root:
        #
        # (0,0) 1 > (0,1) 3
        #             v
        # (1,0) 8   (1,1) 6
        #
        # And,
        # 
        # (0,0) 1   (0,1) 8
        #   v         
        # (1,0) 3 > (1,1) 6
        #
      ].each do |a|
       
        it "enumerates all roots. (but that doesn't guarantee a order.)" do
          should include a
        end
      end

      it "collects the two or more same roots into the one root." do
        should satisfy { |it|
          it.one? do |root| 
            root == [[[0, 0], 1], [[0, 1], 3], [[1, 1], 6]] or
            root == [[[0, 0], 1], [[1, 0], 3], [[1, 1], 6]]
          end
        }
      end

      it "extracts the shortest root from the many same roots." do
        subject.count.should == 4
      end
    end

    context "when specified the movement." do

      let :score_map_movement_specified do
        # Default movement:
        #
        #    xox   #         (0, -1)
        #    o@o   # (-1, 0) (  @  ) (+1,  0)
        #    xox   #         (0, +1)
        # 
        # Set the movement:
        #
        #    ooo   # (-1, -1) (0, -1) (+1, -1)
        #    o@o   # (-1,  0) (  @  ) (+1,  0)
        #    ooo   # (-1, +1) (0, +1) (+1, +1)
        score_map.begin(0, 0).movement([1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1])
      end

      subject { score_map_movement_specified.each.to_a }

      shortest_roots = [
        [[[0, 0], 1]],

        # (0,0) 1   (0,1) 8
        #   v         
        # (1,0) 3   (1,1) 6
        [[[0, 0], 1], [[1, 0], 3]],

        #
        # (0,0) 1 > (0,1) 3
        #              
        # (1,0) 8   (1,1) 6
        [[[0, 0], 1], [[0, 1], 3]],

        # (0,0) 1   (0,1) 6
        #   '---------v
        # (1,0) 6   (1,1) 4
        [[[0, 0], 1], [[1, 1], 4]]
      ]

      shortest_roots.each do |shortest_root|
        it "enumerate all roots." do
          should include shortest_root
        end
      end

      its(:count) { should == shortest_roots.count }

      [
        # (0,0) 1 > (0,1) 3
        #   v---------'
        # (1,0) 5   (1,1) 8
        [[[0, 0], 1], [[0, 1], 3], [[1, 0], 5]],

       
        # (0,0) 1 > (0,1) 3
        #   v---------'
        # (1,0) 5 > (1,1) 8
        [[[0, 0], 1], [[0, 1], 3], [[1, 0], 5], [[1, 1], 8]],
       
        # (0,0) 1 > (0,1) 3
        #             v
        # (1,0)     (1,1) 6
        [[[0, 0], 1], [[0, 1], 3], [[1, 1], 6]],
       
        # (0,0) 1 > (0,1) 3
        #             v
        # (1,0) 8 < (1,1) 6
        [[[0, 0], 1], [[0, 1], 3], [[1, 1], 6], [[1, 0], 8]],

        # (0,0) 1   (0,1) 8
        #   v
        # (1,0) 3 > (1,1) 6
        [[[0, 0], 1], [[1, 0], 3], [[1, 1], 6]],
       
        # (0,0) 1   (0,1) 8
        #   v         ^
        # (1,0) 3 > (1,1) 6
        [[[0, 0], 1], [[1, 0], 3], [[1, 1], 6], [[0, 1], 8]],
       
        # (0,0) 1  .-> (0,1) 5
        #   v      |     
        # (1,0) 3 -'   (1,1) 8
        [[[0, 0], 1], [[1, 0], 3], [[0, 1], 5]],
       
        # (0,0) 1  .-> (0,1) 5
        #   v      |     v
        # (1,0) 3 -'   (1,1) 8
        [[[0, 0], 1], [[1, 0], 3], [[0, 1], 5], [[1, 1], 8]],
       
        # (0,0) 1   (0,1) 6 <.
        #   '---------v      |
        # (1,0) 8   (1,1) 4 -'
        [[[0, 0], 1], [[1, 1], 4], [[0, 1], 6]],

        # (0,0) 1   .- (0,1) 6 <.
        #   '-------+----v      |
        # (1,0) 8 <-'  (1,1) 4 -'
        [[[0, 0], 1], [[1, 1], 4], [[0, 1], 6], [[1, 0], 8]],

        # (0,0) 1   (0,1) 8
        #   '---------v
        # (1,0) 6 < (1,1) 4
        [[[0, 0], 1], [[1, 1], 4], [[1, 0], 6]],

        #   (0,0) 1 .-> (0,1) 8
        # .---|-----'
        # |   '-----------v
        # '- (1,0) 6 <- (1,1) 4
        [[[0, 0], 1], [[1, 1], 4], [[1, 0], 6], [[0, 1], 8]]
      ].each do |long_root|
        it { should_not include long_root }
      end
    end

    context "when specify the score max (6)" do

      subject { score_map.begin(0, 0).limit_score(6).each.to_a }

      [ [[[0, 0], 1]],
        [[[0, 0], 1], [[0, 1], 3]],
        [[[0, 0], 1], [[1, 0], 3]]
      ].each do |in_range|
        it "enumerates all roots which filtered by {score<6}." do
          should include in_range
        end
      end

      its(:count) { should == 3 }

      it "contains not a root the score just equal to 6." do
        should_not include [[[0, 0], 1], [[1, 0], 3], [[1, 1], 6]]
        should_not include [[[0, 0], 1], [[0, 1], 3], [[1, 1], 6]]
      end
    end
  end

  describe "#shortest" do

    let :map do
      [ [1, 2, 3],
        [1, 1, 2],
        [3, 3, 1] ]
    end

    let :score_map do
      described_class.new { |x, y| map[x] && map[x][y] or nil }.begin(0, 0)
    end

    context "when movement is the shape of a cross." do

      subject { score_map.movement([1, 0], [0, 1], [-1, 0], [0, -1]) }

      it do
        subject.shortest(2, 2).should == [ [[0, 0], 1],
                                           [[1, 0], 2],
                                           [[1, 1], 3],
                                           [[1, 2], 5],
                                           [[2, 2], 6] ]
      end
    end

    context "when it can move one square in any direction." do

      subject { score_map.movement([1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, -1]) }

      it do
        subject.shortest(2, 2).should == [ [[0, 0], 1],
                                           [[1, 1], 2],
                                           [[2, 2], 3] ]
      end
    end
  end
end
