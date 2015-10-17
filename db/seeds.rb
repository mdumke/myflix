puts 'create videos'

Video.create([
  {
    title: 'Bicycle Thieves',
    description: 'The film follows the story of a poor father searching post-World War II Rome for his stolen bicycle, without which he will lose the job which was to be the salvation of his young family.',
    large_cover_url: 'tmp/bicycle_thieves_large.jpg',
    small_cover_url: 'tmp/bicycle_thieves_small.jpg'
  },
  {
    title: 'Taxi Driver',
    description: 'Considered an early example of neo-noir, the film stars Robert De Niro as a disturbed loner. He finds a job driving a taxi, and gradually begins engaging in vigilante activities.',
    large_cover_url: 'tmp/taxi_driver_large.jpg',
    small_cover_url: 'tmp/taxi_driver_small.jpg'
  },
  {
    title: 'Groundhog Day',
    description: 'A weather man is reluctantly sent to cover a story about a weather forecasting "rat" (as he calls it). This is his fourth year on the story, and he makes no effort to hide his frustration.',
    large_cover_url: 'tmp/groundhog_day_large.jpg',
    small_cover_url: 'tmp/groundhog_day_small.jpg'
  },
  {
    title: 'Ikiru',
    description: 'The film examines the struggles of a minor Tokyo bureaucrat and his final quest for meaning.',
    large_cover_url: 'tmp/ikiru_large.jpg',
    small_cover_url: 'tmp/ikiru_small.jpg'
  }
])
