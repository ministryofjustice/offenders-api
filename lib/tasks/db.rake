namespace :db do
  desc 'Erase all tables'
  task clear: :environment do
    conn = ActiveRecord::Base.connection
    tables = conn.tables
    tables.each do |table|
      puts "Deleting #{table}"
      conn.drop_table(table, force: :cascade)
    end
  end

  desc 'Task: clear the database, run migrations and seeds'
  task reseed: [:clear, 'db:migrate', 'db:seed'] {}

  desc 'Task: clear the database, run migrations, seeds and reloads demo data'
  task :reload do
    Rake::Task['db:clear'].invoke
    Rake::Task['db:schema:load'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
