require 'dbus'

class ScoreDataServiceObject < DBus::Object

  dbus_interface "com.scorebird.ScoreDataService" do
    dbus_signal :score_data, "score_data:s"
  end

end

class ScoreDataService

  def initialize
    @bus = DBus::SystemBus.instance
    @service = @bus.request_service("com.scorebird.ScoreDataService")
    @service_object = ScoreDataServiceObject.new("/com/scorebird/PrimaryScoreDataServiceInstance")
    @service.export(@service_object)
    @logger = Logger.new(STDOUT)
  end

  def send_score_data(score_data)
    @logger.info("Sending score data: #{score_data}")
    @service_object.score_data(score_data)
  end

  def start
    @logger.info("Starting ScoreDataService...")
    loop = DBus::Main.new
    loop << @bus
    Thread.new { loop.run }
  end

end
