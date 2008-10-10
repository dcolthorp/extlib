require File.join(File.dirname(__FILE__), "spec_helper")

describe Extlib::Logger do

  describe "#new" do
    it "should call set_log with the arguments it was passed." do
      logger = Extlib::Logger.allocate # create an object sans initialization
      logger.should_receive(:set_log).with('a partridge', 'a pear tree', 'a time bomb').and_return(true)
      logger.send(:initialize, 'a partridge', 'a pear tree', 'a time bomb')
    end
  end

  describe "#set_log" do

    before(:each) do
      @stream = StringIO.new
      @logger = Extlib::Logger.new(@stream)
    end

    it "should set the log level to :warn (4) when second parameter is :warn" do
      @logger.set_log(@stream, :warn)
      @logger.level.should == 4
    end

    it "should set the log level to to the passed in Integer log_level" do
      @logger.set_log(@stream, 1)
      @logger.level.should == 1
    end

    it 'allows level value be specified as a String' do
      @logger.set_log(@stream, 'warn')
      @logger.level.should == 4
    end

    it "should default the delimiter to ' ~ '" do
      @logger.delimiter.should eql(" ~ ")
    end
    
  end


  describe "#flush" do
    it "should immediately return if the buffer is empty" do
      @stream = StringIO.new
      @logger = Extlib::Logger.new @stream

      @logger.flush
      @stream.string.should == ""
    end

    it "should call the write_method with the stringified contents of the buffer if the buffer is non-empty" do
      @stream = StringIO.new
      @logger = Extlib::Logger.new @stream

      @logger << "a message"
      @logger << "another message"
      @logger.flush

      @stream.string.should == " ~ a message\n ~ another message\n"
    end

  end

  # There were close specs here, but the logger isn't an IO anymore, and
  # shares a stream with other loggers, so it shouldn't be closing the
  # stream.

  def set_level(level)
    @logger.level = level
  end

  def log_with_method(method)
    simple_matcher do |logger, matcher|
      matcher.failure_message = "Expected #{logger} to log with method #{method}, but it did not."
      matcher.negative_failure_message = "Expected #{logger} NOT to log with method #{method}, but it did."
      
      logger.send(method, "message")
      logger.flush

      logger.log.string == " ~ message\n"
    end
  end

  describe "#debug" do
    before(:each) do
      @stream = StringIO.new
      @logger = Extlib::Logger.new(@stream)
    end

    it "adds to the buffer with debug level" do
      set_level(:debug)
      @logger.should log_with_method(:debug)
    end

    it "does not add to the buffer with info level" do
      set_level(:info)
      @logger.should_not log_with_method(:debug)
    end

    it "does not add to the buffer with warn level" do
      set_level(:warn)
      @logger.should_not log_with_method(:debug)
    end

    it "does not add to the buffer with error level" do
      set_level(:error)
      @logger.should_not log_with_method(:debug)
    end

    it "does not add to the buffer with fatal level" do
      set_level(:fatal)
      @logger.should_not log_with_method(:debug)
    end
  end # #debug


  describe "#info" do
    before(:each) do
      @stream = StringIO.new
      @logger = Extlib::Logger.new(@stream)
    end

    it "adds to the buffer with debug level" do
      set_level(:debug)
      @logger.should log_with_method(:info)
    end

    it "adds to the buffer with info level" do
      set_level(:info)
      @logger.should log_with_method(:info)
    end

    it "does not add to the buffer with warn level" do
      set_level(:warn)
      @logger.should_not log_with_method(:info)
    end

    it "does not add to the buffer with error level" do
      set_level(:error)
      @logger.should_not log_with_method(:info)
    end

    it "does not add to the buffer with fatal level" do
      set_level(:fatal)
      @logger.should_not log_with_method(:info)
    end
  end # #info


  describe "#warn" do
    before(:each) do
      @stream = StringIO.new
      @logger = Extlib::Logger.new(@stream)
    end

    it "adds to the buffer with debug level" do
      set_level(:debug)
      @logger.should log_with_method(:warn)
    end

    it "adds to the buffer with info level" do
      set_level(:info)
      @logger.should log_with_method(:warn)
    end

    it "adds to the buffer with warn level" do
      set_level(:warn)
      @logger.should log_with_method(:warn)
    end

    it "does not add to the buffer with error level" do
      set_level(:error)
      @logger.should_not log_with_method(:warn)
    end

    it "does not add to the buffer with fatal level" do
      set_level(:fatal)
      @logger.should_not log_with_method(:warn)
    end
  end # #warn


  describe "#error" do
    before(:each) do
      @stream = StringIO.new
      @logger = Extlib::Logger.new(@stream)
    end

    it "adds to the buffer with debug level" do
      set_level(:debug)
      @logger.should log_with_method(:error)
    end

    it "adds to the buffer with info level" do
      set_level(:info)
      @logger.should log_with_method(:error)
    end

    it "adds to the buffer with warn level" do
      set_level(:warn)
      @logger.should log_with_method(:error)
    end

    it "adds to the buffer with error level" do
      set_level(:error)
      @logger.should log_with_method(:error)
    end

    it "does not add to the buffer with fatal level" do
      set_level(:fatal)
      @logger.should_not log_with_method(:error)
    end
  end # #error


  describe "#fatal" do
    before(:each) do
      @stream = StringIO.new
      @logger = Extlib::Logger.new(@stream)
    end

    it "adds to the buffer with debug level" do
      set_level(:debug)
      @logger.should log_with_method(:fatal)
    end

    it "adds to the buffer with info level" do
      set_level(:info)
      @logger.should log_with_method(:fatal)
    end

    it "adds to the buffer with warn level" do
      set_level(:warn)
      @logger.should log_with_method(:fatal)
    end

    it "adds to the buffer with error level" do
      set_level(:error)
      @logger.should log_with_method(:fatal)
    end

    it "adds to the buffer with fatal level" do
      set_level(:fatal)
      @logger.should log_with_method(:fatal)
    end
  end # #fatal
end # Extlib::Logger
