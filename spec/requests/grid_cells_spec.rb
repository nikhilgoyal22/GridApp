require 'rails_helper'

RSpec.describe "GridCells", type: :request do

  describe 'POST #set_cell_data' do
    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        post '/api/set_cell_data', params: { row: '', column: '', color: '', format: :json }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq("Row can't be blank. Column can't be blank. Color can't be blank")
      end
    end

    context 'with valid params' do
      it 'returns a created response' do
        post '/api/set_cell_data', params: { row: 1, column: 1, color: 'blue', format: :json }
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'Get Requests' do
    def generate_cell_data
      @user1 = User.create(username: 'user1')
      @user2 = User.create(username: 'user2')

      (['red']*4 + ['blue']*2).each_with_index do |color, i|
        GridCell.create(row: 1, column: i, color: color, user: @user1)
      end

      (['green']*3 + ['blue']*1).each_with_index do |color, i|
        GridCell.create(row: 1, column: i+6, color: color, user: @user2)
      end
    end

    context 'Get #get_cell_data' do
      it 'returns all the cells data' do
        get '/api/get_cell_data', params: { format: :json }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(0)

        generate_cell_data

        get '/api/get_cell_data', params: { format: :json }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(10)
      end
    end

    context 'Get #leaderboard' do
      it 'returns leaderboard data' do
        generate_cell_data

        get '/api/leaderboard', params: { format: :json }
        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)
        expect(data.length).to eq(2)
        expect(data[0].except("user_id")).to eq({"username"=>"user1", "total_count"=>6, "color"=>"red", "color_count"=>4})
        expect(data[1].except("user_id")).to eq({"username"=>"user2", "total_count"=>4, "color"=>"green", "color_count"=>3})
      end
    end
  end
end
