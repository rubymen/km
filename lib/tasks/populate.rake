namespace :db do
  desc 'Populate database'
  task populate: :environment do
    Rake::Task['db:reset'].invoke

    admin = User.create!(birthdate: '1993-12-10',
                         country_code: '33',
                         email: 'admin@epnet.fr',
                         firstname: 'admin',
                         lastname: 'nimda',
                         password: 'adminadmin',
                         password_confirmation: 'adminadmin',
                         phone: '0606060606',
                         street: '4, rue Jules Guesdes',
                         town: 'Lille',
                         type: 'Users::Admin')

    contributor = User.create!(birthdate: '1994-10-01',
                               country_code: '33',
                               email: 'contributor@epnet.fr',
                               firstname: 'contributor',
                               lastname: 'rotubirtnoc',
                               password: 'adminadmin',
                               password_confirmation: 'adminadmin',
                               phone: '0606060606',
                               street: '4, rue Jules Guesdes',
                               town: 'Lille',
                               type: 'Users::Contributor')

    member = User.create!(birthdate: '1992-12-10',
                          country_code: '33',
                          email: 'member@epnet.fr',
                          firstname: 'member',
                          lastname: 'rebmem',
                          password: 'adminadmin',
                          password_confirmation: 'adminadmin',
                          phone: '0606060606',
                          street: '4, rue Jules Guesdes',
                          town: 'Lille',
                          type: 'Users::Member')
  end
end
