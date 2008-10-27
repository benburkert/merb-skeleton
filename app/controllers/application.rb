class Application < Merb::Controller
  BEFORE_OPTIONS = [ :only, :exclude ].freeze

  def self.cache_for(ttl, options = {})
    filter_options = options.only(*BEFORE_OPTIONS)
    cache_option   = options.except(*BEFORE_OPTIONS)

    before lambda { |c| c.cache_for(ttl, cache_option) }, filter_options
  end

  def cache_for(ttl, options = {})
    options['public'] = true if (options.keys & %w[ private no-cache ]).empty?
    options['max-age'] ||= ttl

    headers['Expires']       = (Time.now + ttl).httpdate
    headers['Cache-Control'] = options.map { |k,v| v == true ? k : "#{k}=#{v}" }.join(',')
  end

  def _call_action(*)
    # after warm-up use an optimized _call_action
    self.class.class_eval do
      # time out the action if it takes longer than 1 second
      def _call_action(*)
        repository do
          SystemTimer.timeout(1) do
            super
          end
        end
      end
    end

    # at warm-up just execute the action without any optimizations
    super
  end

end
