# encoding: utf-8
require "logstash/filters/base"
require "sentimental"


# This filter parses a source and calculates a numeric sentiment and stores it in the target.
#
class LogStash::Filters::Sentiment < LogStash::Filters::Base
  config_name "sentiment"

  # The field to perform filter
  #
  # Example, to use the @message field (default) :
  # [source,ruby]
  #     filter { sentiment { source => "message" } }
  config :source, :validate => :string, :default => "message"

  # The name of the field to put the result
  #
  # Example, to place the result into sentiment :
  # [source,ruby]
  #     filter { sentiment { target => "sentiment" } }
  config :target, :validate => :string, :default => "sentiment"

  def filter(event)
    


    #keep it intact on failure.
    begin

      if (event.get(@source).nil? || event.get(@source).empty?)
        @logger.debug("Event to filter, event 'source' field: " + @source + " was null(nil) or blank, doing nothing")
        return
      end

      if @analyzer.nil? || @analyzer.empty?
        init_analyzer
      end

      #@logger.debug("Event to filter", :event => event)
      data = event.get(@source)
     
      result = @analyzer.score(data)

    rescue => e
      @logger.warn("Exception catch on sentiment filter", :event => event, :error => e)

      # force a re-initialize on error to be safe
      init_analyzer

    else
      
      event.set(@target, result)
      filter_matched(event) if !result.nil?      

    end
  end # def filter

  def init_analyzer

    @analyzer = Sentimental.new
    @analyzer.load_defaults
    @logger.debug("Analyzer initialisation done")
  end # def init_analyzer


end # class LogStash::Filters::Sentiment
