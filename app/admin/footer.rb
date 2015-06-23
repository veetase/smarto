module ActiveAdmin
  module Views
    class Footer < Component

      def build
        super :id => "footer"
        div do
          small "Powered by Bixuange"
        end
      end

    end
  end
end
