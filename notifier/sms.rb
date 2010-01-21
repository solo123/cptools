require 'yaml'
require 'soap/wsdlDriver'

class Sms
  def initialize
    #Open the YAML configuration file
    @config = YAML.load_file("../config/config.yml")["development"]
    @service = SOAP::WSDLDriverFactory.new(@config["sms_wsdl"]).create_rpc_driver
    # Log SOAP request and response
    # @service.wiredump_file_base = "soap-log.txt"
  end
  
  def GetBalance
    begin
      @service.GetBalance(:sn => @config["sms_sn"], :pwd => @config["sms_pwd"]).getBalanceResult.to_i
    rescue
      -1
    end
  end
  
  def SendSms(mobile, content)
    begin
      @service.SendSMS(:sn => @config["sms_sn"], :pwd => @config["sms_pwd"], :mobile => mobile, :content => content).sendSMSResult.to_i
    rescue
      -1
    end
  end
end
