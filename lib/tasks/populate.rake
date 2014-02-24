namespace :db do
  desc 'Populate database'
  task populate: :environment do
    Rake::Task['db:reset'].invoke

    admin = User.create!( birthdate:              '1993-12-10',
                          country_code:           'France',
                          email:                  'admin@epnet.fr',
                          firstname:              'admin',
                          lastname:               'nimda',
                          password:               'adminadmin',
                          password_confirmation:  'adminadmin',
                          phone:                  '0606060606',
                          street:                 '4, rue Jules Guesdes',
                          town:                   'Lille',
                          type:                   'Users::Admin')

    contributor = User.create!( birthdate:              '1994-10-01',
                                country_code:           'France',
                                email:                  'contributor@epnet.fr',
                                firstname:              'contributor',
                                lastname:               'rotubirtnoc',
                                password:               'adminadmin',
                                password_confirmation:  'adminadmin',
                                phone:                  '0606060606',
                                street:                 '4, rue Jules Guesdes',
                                town:                   'Lille',
                                type:                   'Users::Contributor')

    member = User.create!(birthdate:              '1992-12-10',
                          country_code:           'France',
                          email:                  'member@epnet.fr',
                          firstname:              'member',
                          lastname:               'rebmem',
                          password:               'adminadmin',
                          password_confirmation:  'adminadmin',
                          phone:                  '0606060606',
                          street:                 '4, rue Jules Guesdes',
                          town:                   'Lille',
                          type:                   'Users::Member')

    document1 = admin.documents.create!(title:        'Mon premier document',
                                        description:  'Une petite description du premier document.',
                                        content:      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vestibulum nulla ligula, in interdum nisl mollis ut. Sed auctor nunc nec velit congue rutrum. Phasellus eu erat sed libero euismod malesuada. In sed sem viverra, interdum tellus eu, elementum turpis. Fusce elementum, odio sit amet consectetur vehicula, magna elit convallis sapien, a tincidunt tellus orci vitae nibh. Aenean cursus ligula id neque vehicula tincidunt. Aliquam quis molestie lorem, sed porta tortor. Duis elementum at felis vel semper. Vivamus interdum nisl ac arcu consectetur fermentum. Quisque id nunc lacus. Fusce tincidunt ac odio et cursus. Vestibulum id dui sit amet risus suscipit imperdiet ultrices id ligula. Nullam justo leo, rutrum at nisl interdum, ultricies rutrum mauris.')

    document2 = contributor.documents.create!(title:        'Mon second document',
                                              description:  'Une longue description du second document par ce qu\'il est vraiment super génial et qu\'il faut tester la taille de notre contenu.',
                                              content:      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vestibulum nulla ligula, in interdum nisl mollis ut. Sed auctor nunc nec velit congue rutrum. Phasellus eu erat sed libero euismod malesuada. In sed sem viverra, interdum tellus eu, elementum turpis. Fusce elementum, odio sit amet consectetur vehicula, magna elit convallis sapien, a tincidunt tellus orci vitae nibh. Aenean cursus ligula id neque vehicula tincidunt. Aliquam quis molestie lorem, sed porta tortor. Duis elementum at felis vel semper. Vivamus interdum nisl ac arcu consectetur fermentum. Quisque id nunc lacus. Fusce tincidunt ac odio et cursus. Vestibulum id dui sit amet risus suscipit imperdiet ultrices id ligula. Nullam justo leo, rutrum at nisl interdum, ultricies rutrum mauris.')

    comment1 = Comment.create!( content:      'Ce document est génial !',
                                document_id:  document1.id,
                                user_id:      admin.id)

    comment2 = Comment.create!( content:      'Je ne comprends pas la ligne #45, pouvez-vous m\'aider?',
                                document_id:  document1.id,
                                user_id:      contributor.id)

    comment2rep = Comment.create!(  content:      'J\'ai pas le temps de t\'expliquer.',
                                    document_id:  document1.id,
                                    user_id:      admin.id,
                                    comment_id:   comment2.id)

    comment3 = Comment.create!( content:      'Lorem ipsum dolor sit amet',
                                document_id:  document2.id,
                                user_id:      member.id)

    comment4 = Comment.create!( content:      'J\'adore ce document ! Merci beaucoup !',
                                document_id:  document1.id,
                                user_id:      member.id)

    tag1 = Tag.create!(title: 'Javascript')

    tag2 = Tag.create!(title: 'HTML')

    tag3 = Tag.create!(title: 'PHP')

    tag4 = Tag.create!(title: 'CSS')

    tag5 = Tag.create!(title: 'Ruby on Rails')

    DocumentsTags.create!(document_id: document1.id, tag_id: tag4.id)
    DocumentsTags.create!(document_id: document2.id, tag_id: tag1.id)
    DocumentsTags.create!(document_id: document2.id, tag_id: tag3.id)
  end
end
