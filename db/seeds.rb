puts 'creating categories'

Category.create([
  { name: 'Comedy' },
  { name: 'Drama' },
  { name: 'Series' }
])

puts 'create videos'

3.times do
  Video.create([
    {
      title: 'Bicycle Thieves',
      description: 'The film follows the story of a poor father searching post-World War II Rome for his stolen bicycle, without which he will lose the job which was to be the salvation of his young family.',
      large_cover_url: '/tmp/bicycle_thieves_large.jpg',
      small_cover_url: '/tmp/bicycle_thieves_small.jpg',
      category: Category.find_by_name('Drama')
    },
    {
      title: 'Taxi Driver',
      description: 'Considered an early example of neo-noir, the film stars Robert De Niro as a disturbed loner. He finds a job driving a taxi, and gradually begins engaging in vigilante activities.',
      large_cover_url: '/tmp/taxi_driver_large.jpg',
      small_cover_url: '/tmp/taxi_driver_small.jpg',
      category: Category.find_by_name('Drama')
    },
    {
      title: 'Groundhog Day',
      description: 'A weather man is reluctantly sent to cover a story about a weather forecasting "rat" (as he calls it). This is his fourth year on the story, and he makes no effort to hide his frustration.',
      large_cover_url: '/tmp/groundhog_day_large.jpg',
      small_cover_url: '/tmp/groundhog_day_small.jpg',
      category: Category.find_by_name('Comedy')
    },
    {
      title: 'Ikiru',
      description: 'The film examines the struggles of a minor Tokyo bureaucrat and his final quest for meaning.',
      large_cover_url: '/tmp/ikiru_large.jpg',
      small_cover_url: '/tmp/ikiru_small.jpg',
      category: Category.find_by_name('Drama')
    },
    {
      title: 'Futurama',
      description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dolorem omnis, incidunt numquam repellendus impedit, voluptatem minus magni suscipit architecto similique. At cupiditate repudiandae et in possimus saepe provident, suscipit quibusdam.',
      large_cover_url: '/tmp/futurama.jpg',
      small_cover_url: '/tmp/futurama.jpg',
      category: Category.find_by_name('Series')
    },
    {
      title: 'Monk',
      description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quam exercitationem voluptas voluptate praesentium possimus consectetur harum iusto eum, accusamus, rem asperiores reprehenderit officiis magni dolore modi laboriosam nisi dignissimos numquam.',
      large_cover_url: '/tmp/monk_large.jpg',
      small_cover_url: '/tmp/monk.jpg',
      category: Category.find_by_name('Series')
    },
    {
      title: 'South Park',
      description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Perspiciatis cumque mollitia ipsam. Laudantium odio commodi alias praesentium, natus labore fuga placeat culpa, eius quis quidem, dicta adipisci ipsa enim eligendi.',
      large_cover_url: '/tmp/south_park.jpg',
      small_cover_url: '/tmp/south_park.jpg',
      category: Category.find_by_name('Series')
    },
    {
      title: 'Family Guy',
      description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iure id eum dolorem quisquam corporis. Modi, cum eaque numquam, inventore laboriosam et magnam optio, eos dolorem voluptatibus iure reiciendis deleniti quo.',
      large_cover_url: '/tmp/family_guy.jpg',
      small_cover_url: '/tmp/family_guy.jpg',
      category: Category.find_by_name('Series')
    },
    {
      title: 'The Boss of it all',
      description: 'An IT company hires an actor to serve as the company\'s president in order to help the business get sold to a cranky Icelander.',
      large_cover_url: '/tmp/the_boss_of_it_all',
      small_cover_url: '/tmp/the_boss_of_it_all.jpg',
      category: Category.find_by_name('Comedy')
    }
  ])
end

puts 'create users'

User.create([
  { email: 'matthias@example.com', password: '123', full_name: 'Matthias Dumke' },
  { email: 'lambda@example.com', password: '123', full_name: 'Lamba Calculus' },
  { email: 'java@example.com', password: '123', full_name: 'Java Script' }
])

puts 'create relationships'

Relationship.create([
  { leader: User.first, follower: User.second },
  { leader: User.first, follower: User.third },
  { leader: User.second, follower: User.first },
  { leader: User.second, follower: User.third },
  { leader: User.third, follower: User.second }
])

puts 'create reviews'

30.times do
  Review.create(
    {
      rating: rand(5) + 1,
      text: Faker::Lorem.words(20).join(' '),
      video: Video.all.sample,
      user: User.all.sample
    }
  )
end

puts 'create queue items'

User.all.each_with_index do |user, user_index|
  Video.limit(4).offset(user_index * 4).each_with_index do |video, video_index|
    QueueItem.create(queue_position: video_index + 1, user: user, video: video) 
  end
end

