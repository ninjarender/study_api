require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  path '/api/v1/users' do
    let!(:user) { create(:user) }

    get('show user') do
      tags 'User'
      consumes 'application/json'
      security [Bearer: {}]
      response(200, 'successful') do
        let(:Authorization) { "Bearer #{user.password_digest}" }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['id']).to eq(user.id)
        end
      end
    end

    # put('update user') do
    #   response(200, 'successful') do

    #     after do |example|
    #       example.metadata[:response][:content] = {
    #         'application/json' => {
    #           example: JSON.parse(response.body, symbolize_names: true)
    #         }
    #       }
    #     end
    #     run_test!
    #   end
    # end

    # delete('delete user') do
    #   response(200, 'successful') do

    #     after do |example|
    #       example.metadata[:response][:content] = {
    #         'application/json' => {
    #           example: JSON.parse(response.body, symbolize_names: true)
    #         }
    #       }
    #     end
    #     run_test!
    #   end
    # end

    post('create user') do
      tags 'User'
      consumes 'application/json'
      parameter name: :user_params, in: :body, schema: {
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
            },
            required: %w[email password password_confirmation first_name last_name]
          }
        }
      }

      response(201, 'created') do
        let(:password) { Faker::Internet.password }
        let!(:user_params) {
          {
            user: {
              email: Faker::Internet.email,
              password: password,
              password_confirmation: password,
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name
            }
          }
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          
          expect(data['email']).to eq(user_params[:user][:email])
          expect(data['first_name']).to eq(user_params[:user][:first_name])
          expect(data['last_name']).to eq(user_params[:user][:last_name])
          expect(User.count).to eq(2)
        end
      end

      response(422, 'errors') do
        let!(:user_params) {
          {
            user: {
              email: 'sadkflsdf',
              password: 'aksdlka',
              password_confirmation: 'sldferieo',
              first_name: nil,
              last_name: nil
            }
          }
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['email']).to eq(['is invalid'])
          expect(data['password_confirmation']).to eq(["doesn't match Password"])
          expect(data['first_name']).to eq(["can't be blank"])
          expect(data['last_name']).to eq(["can't be blank"])
          expect(User.count).to eq(1)
        end
      end
    end
  end
end
