# An anonymous user
class Guest
  # Determines whether the user is a guest
  #
  # This will always be false
  def is_guest?;true;end
  
  # Determines whether the user is part of any or all of the roles
  # specified.
  #
  # This will always be false
  def is_in_roles?(*args);false;end
end