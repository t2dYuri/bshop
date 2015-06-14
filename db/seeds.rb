Product.delete_all

Product.create!(title: 'CoffeeScript',
  description: %{CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, and safer code.},
  image_url: 'test01.jpg',
  price: 36.00)

Product.create!(title: 'Programming Ruby 1.9 & 2.0',
  description: 'Ruby is the fastest growing and most exciting dynamic language out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox.',
  image_url: 'test02.jpg',
  price: 49.95)

Product.create!(title: 'Rails Test Prescriptions',
  description: '<em>Rails Test Prescriptions</em> is a comprehensive guide to testing Rails applications, covering Test-Driven Development from both a theoretical perspective (why to test) and from a practical perspective (how to test effectively). It covers the core Rails testing tools and procedures for Rails 2 and Rails 3, and introduces popular add-ons, including Cucumber, Shoulda.',
  image_url: 'test03.jpg',
  price: 34.95)

Product.create!(title: 'CCleaner Portable',
  description: 'CCleaner - Небольшая, бесплатная, легкая в использовании, но очень полезная и функциональная утилита для оптимизации скорости работы и загрузки операционной системы, очистки от устаревших временных файлов и журналов Windows, исправления ошибок в системном реестре, управления временными файлами и логами популярных программ.',
  image_url: 'test04.jpg',
  price: 22.95)

Product.create!(title: 'Avast Free Antivirus',
  description: 'Avast Free Antivirus 2015 has added utilities to an already comprehensive set of security tools. The new Smart Scan detects vulnerabilities in your home network, checks for program updates, and fixes PC performance issues with just one click.',
  image_url: 'test05.jpg',
  price: 48.50)

Product.create!(title: 'Smart Defrag',
  description: 'IObit Smart Defrag 4 optimizes your PC to take full advantage of SSD performance while defragmenting your hard disks. Its SSD Trim tool automatically enables system tweaks that typically require experience to apply. Smart Defrag 4 updates include a new defrag engine, specialized Game Defrag, a cool new look, and many more language options (35 and counting).',
  image_url: 'test06.jpg',
  price: 56.00)

Product.create!(title: 'Driver Booster 2',
  description: 'IObit Driver Booster 2 scans your PC for out-of-date drivers and updates them for you. It can scan automatically when you launch a program or when you connect a device. Or you can set fixed intervals for scans and update drivers one by one or all at once with a single click. ',
  image_url: 'test07.jpg',
  price: 99.00)

Product.create!(title: 'File Viewer Lite',
  description: 'File Viewer Lite is a free Windows utility that allows you to view any file. It can display the native view of over 120 of the most popular file formats, including Microsoft Word documents, Microsoft Excel spreadsheets, PDFs, audio files, video files, image files, camera raw images, and more.',
  image_url: 'test08.jpg',
  price: 99.95)

Product.create!(title: 'MiniTool Partition Wizard ',
  description: 'MiniTool Partition Wizard Home Edition 8 adds disk conversion and copying to what was already one of our favorite disk partitioning tools, free or not. It creates, deletes, aligns, moves, resizes, recovers, splits, joins, hides, copies, and converts partitions or entire disks.',
  image_url: 'test09.jpg',
  price: 105.99)

Product.create!(title: 'IrfanView',
  description: 'Irfan View is a compact and powerful photo editing program that gives you the tools to touch up and add effects to your photos. You can set images as your desktop wallpaper directly from the app, and put the finishing touches on all your photos with just a few clicks.',
  image_url: 'test10.jpg',
  price: 85.00)

User.create!(name: 'Admin Yuri Trend',
             email: 'test@mail.com',
             password:              'polikpol',
             password_confirmation: 'polikpol',
             admin: true)

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@mail.org"
  password = 'password'
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,)
end
