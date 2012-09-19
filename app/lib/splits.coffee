User = require 'zooniverse/lib/models/user'

module.exports =
  classifier_messaging:
    default:
      header: -> 'Did you know'
      body: -> 'You can collect your favorite storm images and discuss them in Talk.'
      isShown: -> true
    
    a:
      header: -> ''
      body: -> ''
      isShown: -> true
    
    b:
      header: -> 'Good job'
      body: (userCount) -> "You and #{ userCount } other Zooniverse volunteers have contributed to Cyclone Center."
      isShown: -> User.current.project.reveal_count is undefined or User.current.project.reveal_count <= 1
    
    c:
      header: -> 'Good job'
      body: (userCount) -> "You and #{ userCount } other Zooniverse volunteers have contributed to Cyclone Center."
      isShown: -> User.current.project.reveal_count is undefined or User.current.project.reveal_count <= 3
    
    d:
      header: -> 'Good job'
      body: -> 'You just successfully finished classifying satellite images of tropical cyclones'
      isShown: -> User.current.project.reveal_count is undefined or User.current.project.reveal_count <= 1
    
    e:
      header: -> 'Good job'
      body: -> 'You just successfully finished classifying satellite images of tropical cyclones.'
      isShown: -> User.current.project.reveal_count is undefined or User.current.project.reveal_count <= 3
    
    f:
      header: -> 'Good job'
      body: -> 'Your work is directly helping the science of meteorology to better understand the formation and development of tropical cyclones.'
      isShown: -> User.current.project.reveal_count is undefined or User.current.project.reveal_count <= 1
    
    g:
      header: -> 'Good job'
      body: -> 'Your work is directly helping the science of meteorology to better understand the formation and development of tropical cyclones.'
      isShown: -> User.current.project.reveal_count is undefined or User.current.project.reveal_count <= 3
