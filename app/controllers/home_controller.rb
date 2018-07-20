class HomeController < ApplicationController
  def get_user
    render json: guest_user
  end

  def get_cell_data
    render json: GridCell.joins(:user).select('grid_cells.*, users.username')
  end

  def set_cell_data
    cell = GridCell.find_by(row: cell_params[:row], column: cell_params[:column])
    if cell
      cell.update(cell_params.merge({user_id: guest_user.id}))
    else
      cell = GridCell.create(cell_params.merge({user_id: guest_user.id}))
    end
    render json: cell
  end

  def leaderboard
    leaders = GridCell.joins(:user).select(
      "grid_cells.user_id, users.username, count(grid_cells.color)"
    ).group('grid_cells.user_id, users.id').order("count desc").limit(5)

    data = leaders.map do |leader| 
      most_used_color = GridCell.where(user_id: leader['user_id']).select('color, count(color)').group(:color).order('count DESC').limit(1)[0]
      {
        user_id: leader['user_id'], username: leader['username'], total_count: leader['count'],
        color: most_used_color['color'], color_count: most_used_color['count']
      }
    end

    render json: data
  end

  private

  def cell_params
    params.permit(:row, :column, :color)
  end
end