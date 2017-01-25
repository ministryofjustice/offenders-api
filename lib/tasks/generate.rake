namespace :generate do
  desc 'Generate dummy offender records (default 100k) with 1-5 identities per offender'
  task :dummy_offenders, [:count] => :environment do |t, args|
    count = args[:count].to_i > 0 ? args[:count].to_i : 100_000

    Offender.destroy_all

    count.times do
      offender = FactoryGirl.build(:offender)
      next unless offender.save
      identity = nil
      [1, 2, 3, 4, 5].sample.times do
        identity = FactoryGirl.create(:identity, :active, offender: offender)
      end
      offender.update current_identity: identity
    end
  end
end
