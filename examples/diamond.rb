# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__) + '/../lib'

require 'game_pencil'

MAX_WIDTH = 40
MAX_HEIGHT = 15

board = Array.new(MAX_HEIGHT) { [] }

GamePencil::Pencil::ScoreMap.new do |x, y|
  # 盤面を表現する。このブロックが1を返せば通行可能、nilなら通行不可能
  (x < MAX_WIDTH && y < MAX_HEIGHT) ? 1 : nil
end.
  begin( MAX_WIDTH/2 , MAX_HEIGHT/2 ).         # 探索を開始する地点。今回は中心
  movement([1, 0], [-1, 0], [0, 1], [0, -1]).  # 探索できる範囲。これは上下左右
  limit_score(MAX_HEIGHT/2).                   # 探索できる距離。
  each do |root|
    root.each do |(x,y), score|
      board[y][x] ||= '*'
    end
  end

puts board.map { |line| line.map { |item| item ? item : ' ' }.join }.join("\n")

# Example output:
#
#                    *
#                   ***
#                  *****
#                 *******
#                *********
#               ***********
#                *********
#                 *******
#                  *****
#                   ***
#                    *
