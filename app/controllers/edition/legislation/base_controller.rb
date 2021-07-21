class Edition::Legislation::BaseController < Edition::BaseController
  include FeatureFlags

  feature_flag :legislation

end
