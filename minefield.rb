class Minefield
  attr_reader :row_count, :column_count
  attr_accessor :mine_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count
    @minefield = []
    make_minefield
  end

  def make_minefield
    row_count.times do
      column = []
      column_count.times do
        column << Cell.new(0,false)
      end
      @minefield << column
    end
    put_mines
    @minefield
  end

  def put_mines
    while @mine_count > 0 do
      if @minefield[rand(row_count)][rand(column_count)].value == 0
        @minefield[rand(row_count)][rand(column_count)].value = 1
        @mine_count -= 1
      end
    end
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @minefield[row][col].status
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    if cell_cleared?(row,col) == false
      @minefield[row][col].status = true
      if adjacent_mines(row,col) == 0 && @minefield[row][col].value == 0
        clear(row+1,col+1) if out_of_bounds(row+1,col+1) == false
        clear(row,col+1) if out_of_bounds(row,col+1) == false
        clear(row-1,col+1) if out_of_bounds(row-1,col+1) == false
        clear(row+1,col) if out_of_bounds(row+1,col) == false
        clear(row-1,col) if out_of_bounds(row-1,col) == false
        clear(row+1,col-1) if out_of_bounds(row+1,col-1) == false
        clear(row,col-1) if out_of_bounds(row,col-1) == false
        clear(row-1,col-1) if out_of_bounds(row-1,col-1) == false
      end
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    @minefield.each_with_index do |row,ri|
      row.each_with_index do |col,ci|
        if cell_cleared?(ri,ci) == true && @minefield[ri][ci].value == 1
          return true
        end
      end
    end
    return false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    @minefield.each_with_index do |row,ri|
      row.each_with_index do |col,ci|
        if cell_cleared?(ri,ci) == false && @minefield[ri][ci].value == 0
          return false
        end
      end
    end
    return true
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    count = 0
    count += @minefield[row-1][col-1].value if out_of_bounds(row-1,col-1) == false
    count += @minefield[row][col-1].value if out_of_bounds(row,col-1) == false
    count += @minefield[row+1][col-1].value if out_of_bounds(row+1,col-1) == false
    count += @minefield[row-1][col].value if out_of_bounds(row-1,col) == false
    count += @minefield[row+1][col].value if out_of_bounds(row+1,col) == false
    count += @minefield[row-1][col+1].value if out_of_bounds(row-1,col+1) == false
    count += @minefield[row][col+1].value if out_of_bounds(row,col+1) == false
    count += @minefield[row+1][col+1].value if out_of_bounds(row+1,col+1) == false
    count
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
     @minefield[row][col].value == 1
  end

  def out_of_bounds(row,col)
    return row < 0 || row >= @row_count || col < 0 || col >= column_count
  end
end
