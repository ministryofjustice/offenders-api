# require 'rails_helper'
#
# RSpec.describe ParseCsv do
#   let(:csv_data) { fixture_file_upload('files/offenders.csv', 'text/csv') }
#
#   describe '#call' do
#     context 'when parsing offenders' do
#       context 'when prionsers do not exist in local database' do
#         before { described_class.call(csv_data) }
#
#         it 'creates offender records' do
#           expect(Offender.count).to eq(2)
#         end
#
#         it 'imports all the fields correctly' do
#           offender = Offender.find_by!(noms_id: 'A1234BC')
#
#           expect(offender.given_name).to eq('BOB')
#           expect(offender.middle_names).to eq('FRANKIE, LEE')
#           expect(offender.surname).to eq('DYLAN')
#           expect(offender.title).to eq('MR')
#           expect(offender.date_of_birth).to eq(Date.civil(1941, 5, 24))
#           expect(offender.gender).to eq('M')
#           expect(offender.pnc_number).to eq('05/123456A')
#           expect(offender.nationality_code).to eq('BRIT')
#           expect(offender.cro_number).to eq('123456/01A')
#           expect(offender.establishment_code).to eq('LEI')
#         end
#       end
#
#       context 'when prionsers exist in local database' do
#         before do
#           create(:offender, noms_id: 'A1234BC')
#           create(:offender, noms_id: 'Z9876YX')
#           described_class.call(csv_data)
#         end
#
#         it 'does not create new offender records' do
#           expect(Offender.count).to eq(2)
#         end
#
#         it 'updates all the fields correctly' do
#           offender = Offender.find_by!(noms_id: 'A1234BC')
#
#           expect(offender.given_name).to eq('BOB')
#           expect(offender.middle_names).to eq('FRANKIE, LEE')
#           expect(offender.surname).to eq('DYLAN')
#           expect(offender.title).to eq('MR')
#           expect(offender.date_of_birth).to eq(Date.civil(1941, 5, 24))
#           expect(offender.gender).to eq('M')
#           expect(offender.pnc_number).to eq('05/123456A')
#           expect(offender.nationality_code).to eq('BRIT')
#           expect(offender.cro_number).to eq('123456/01A')
#           expect(offender.establishment_code).to eq('LEI')
#         end
#       end
#     end
#
#     context 'when parsing identities' do
#       let(:csv_data) { fixture_file_upload('files/identities.csv', 'text/csv') }
#
#       context 'when there is an existing offender on the noms_id' do
#         before do
#           create(:offender, noms_id: 'A1234BC')
#           described_class.call(csv_data)
#         end
#
#         it 'creates identities records' do
#           expect(Offender.find_by!(noms_id: 'A1234BC').identities.count).to eq(2)
#         end
#
#         it 'imports all the fields correctly' do
#           first_identity = Offender.find_by!(noms_id: 'A1234BC').identities.first
#
#           expect(first_identity.given_name).to eq('JOHN')
#           expect(first_identity.middle_names).to eq('WESLEY, BOBBY')
#           expect(first_identity.surname).to eq('HARDIN')
#           expect(first_identity.gender).to eq('M')
#           expect(first_identity.date_of_birth).to eq(Date.civil(1991, 7, 17))
#         end
#       end
#
#       context 'when there is not an existing offender' do
#         it 'throws an error with the line number' do
#           expect { described_class.call(csv_data) }
#             .to raise_error(ParseCsv::ParsingError)
#         end
#       end
#     end
#
#     context 'invalid CSV data' do
#       context 'with invalid headers' do
#         let(:csv_data) { fixture_file_upload('files/offenders_with_invalid_headers.csv', 'text/csv') }
#
#         it 'throws a MalformedHeaderError' do
#           expect { described_class.call(csv_data) }
#             .to raise_error(ParseCsv::MalformedHeaderError)
#         end
#       end
#
#       context 'with invalid records' do
#         let(:csv_data) { fixture_file_upload('files/offenders_with_invalid_content.csv', 'text/csv') }
#
#         it 'throws an error with the line number' do
#           expect { described_class.call(csv_data) }
#             .to raise_error(ParseCsv::ParsingError)
#         end
#       end
#     end
#   end
# end
