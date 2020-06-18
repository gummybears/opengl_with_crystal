module CrystGLFW
  module Event
    # Represents an event wherein a window's focus is toggled on or off.
    struct WindowToggleFocus < Any
      getter window : Window

      # :nodoc:
      def initialize(@window : Window, @focused : Bool)
      end

      def focused?
        @focused
      end
    end
  end
end
