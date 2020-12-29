class Edition::Poll::BaseController < Edition::BaseController
  helper_method :namespace

  private

    def namespace
      "admin"
    end
end
