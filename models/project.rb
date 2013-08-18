# Public: The model that is used in the portfolio of the application.
#
# TODO: Currently, the portfolio is all static. This model is not being used at
# all. That needs to change.
class Project
  include Taggable
  include Seedable
  include Pageable
end
