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
    render json: cell.reload
  end

  private

  def cell_params
    params.permit(:row, :column, :color)
  end
end