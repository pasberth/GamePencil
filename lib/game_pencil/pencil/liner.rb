module GamePencil

  module Pencil

    module Liner

      def  trace_toward((*direction))
        return Enumerator.new(self, :trace_toward, direction) unless block_given?

        xs = [0] * direction.length

        loop do
          yield *xs
          xs.map!.with_index { |x, i| x + direction[i] }
        end
      end

      def trace_from((*start), (*direction))
        return Enumerator.new(self, :trace_from, start, direction) unless block_given?

        trace_toward(direction) do |*xs|
          yield *start.zip(xs).map{|a, b| a + b }
        end
      end

      def trace_line((*start), (*goal), &block)
        return Enumerator.new(self, :trace_line, start, goal) unless block_given?

        direction_base = start.zip(goal).map { |p, q| (p - q).abs }.max
        direction = start.zip(goal).map { |p, q| (q - p).to_f / direction_base }
        direction_base.ceil.times.zip trace_from(start, direction) do |i, (*xs)|
          xs.map! &:truncate
          yield *xs
        end
      end
    end
  end
end
