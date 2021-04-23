class BackupsController < ApplicationController
  #protect_from_forgery with: :null_session
  # TODO make secure by filtering IP and passcode
  def upload
    backstage = Gsheet.new("Backstage App", "Devices")
    backstage.unique_cells("Device Name")
    data = params.permit(:device_name, :company_name, :atera_id, :last_backup_date, :backups_completed, :backups_started, :backups_failed, :api_key)
    backstage.insert_rows([ data[:device_name], data[:company_name], 0,0,data[:atera_id], data[:last_backup_date], data[:backups_started], data[:backups_completed], data[:backup_faileds], data[:api_key]])
    backstage.save
    
    #head :ok #Commented this out because jets uses rails 5
    render plain: "OK ", statsus: 200
    #format.any { render :json => {:response => 'OK' },:status => 200}

  end

end
