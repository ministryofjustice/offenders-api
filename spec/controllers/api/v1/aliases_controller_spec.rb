# require 'rails_helper'
#
# RSpec.describe Api::V1::AliasesController, type: :controller do
#   let!(:application) { create(:application) }
#   let!(:token)       { create(:access_token, application: application) }
#   let!(:prisoner) { create(:prisoner, noms_id: 'A1234BC', date_of_birth: Date.parse('19801010')) }
#
#   context 'when authenticated' do
#     before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }
#
#     describe 'GET #index' do
#       before { get :index, prisoner_id: prisoner }
#
#       it 'returns status 200' do
#         expect(response.status).to be 200
#       end
#
#       it 'returns JSON collection of the prisoner\'s aliases' do
#         expect(JSON.parse(response.body)).to match_array(prisoner.aliases)
#       end
#     end
#
#     describe 'GET #show' do
#       let(:prisoner) do
#         prisoner = create(:prisoner)
#         prisoner.aliases.build(given_name: 'Tommy', surname: 'Smith', date_of_birth: 20.years.ago.to_date, gender: 'M')
#         prisoner.save
#         prisoner.reload
#       end
#
#       before { get :show, prisoner_id: prisoner, id: prisoner.aliases.first }
#
#       it 'returns status 200' do
#         expect(response.status).to be 200
#       end
#     end
#
#     describe 'POST #create' do
#
#     end
#
#     describe 'PATCH #update' do
#
#     end
#
#     describe 'DELETE #destroy' do
#
#     end
#   end
#
#   context 'when unauthenticated' do
#     describe 'GET #index' do
#       before { get :index, prisoner_id: prisoner }
#
#       it 'returns status 401' do
#         expect(response.status).to be 401
#       end
#     end
#
#     describe 'GET #show' do
#       before { get :show, prisoner_id: prisoner, id: 1 }
#
#       it 'returns status 401' do
#         expect(response.status).to be 401
#       end
#     end
#
#     describe 'POST #create' do
#
#     end
#
#     describe 'PATCH #update' do
#
#     end
#
#     describe 'DELETE #destroy' do
#
#     end
#   end
# end
