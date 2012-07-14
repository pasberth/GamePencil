module GamePencil

  class MultidimensionalArray

    def initialize array = []
      @array = array.to_ary.map { |a| a.respond_to?(:to_ary) ? MultidimensionalArray.new(a.to_ary) : a }
    end

    def [] *xs
      xs.inject(@array) { |d, x| d ? d[x] : nil }
    end

    def []= *args
      val = args.pop
      x = args.pop
      xs = args
      xs.inject(@array) { |d, x| d[x] ||= MultidimensionalArray.new([]) }[x] = val
    end

    def clone
      MultidimensionalArray.new(@array)
    end

    def to_ary
      @array
    end
  end
end
