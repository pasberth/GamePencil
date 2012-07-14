require 'game_pencil/multidimensional_array'

module GamePencil

  module Pencil

    class ScoreMap

      def initialize &cost_map
        @cost_map = cost_map || proc {}
        @begin_point = nil
        @movement_points = nil
        @score_max = Float::INFINITY
      end

      def cost_map *point
        @cost_map.call *point
      end

      def begin_point
        @begin_point or raise ArgumentError, "ScoreMap#begin_point hasn't initialized."
      end

      def movement_points
        @movement_points or raise ArgumentError, "ScoreMap#movement_points hasn't initialized."
      end

      attr_reader :score_max

      def begin *point
        clone.instance_eval { @begin_point = point.freeze; self }
      end

      def movement *points
        clone.instance_eval { @movement_points = points.freeze; self }
      end

      def limit_score max
        clone.instance_eval { @score_max = max; self }
      end

      def each
        return Enumerator.new(self, :each) unless block_given?

        score_map = MultidimensionalArray.new
        score_map[*begin_point] = cost_map(*begin_point)
        queue = [ { score: cost_map(*begin_point),
                    root: [begin_point],
                    a_root: [[begin_point, cost_map(*begin_point)]],
                    point: begin_point }]

        while cur = queue.shift
          score = cur[:score]
          point = cur[:point]

          next if score > score_map[*point]

          root = cur[:root]

          yield cur[:a_root]

          movement_points.each do |mov|
            nex = point.zip(mov).map { |a, b| a + b }
            next if nex.any? { |x| x  < 0 } or root.include? nex or cost_map(*nex).nil?

            nex_score = score + cost_map(*nex)
            if (it = score_map[*nex]).nil? or nex_score < it and nex_score < score_max
              score_map[*nex] = nex_score
              queue << { score: nex_score,
                         root: root + [nex],
                         a_root: cur[:a_root] + [[nex, nex_score]],
                         point: nex }
            end
          end
        end
      end

      def shortest *point
        each.find { |a| a.last[0] == point }
      end
    end
  end
end
