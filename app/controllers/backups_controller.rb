class BackupsController < ApplicationController
  #protect_from_forgery with: :null_session
  # TODO make secure by filtering IP and passcode
  def upload
    backstage = Gsheet.new("Backstage App", "Devices")
    backstage.unique_cells("Computer Num")
    data = params.permit(
      :device_name, 
      :company_name, 
      :atera_id, 
      :last_backup_date, 
      :backups_completed, 
      :backups_started, 
      :backups_failed, 
      :api_key, 
      :hdd_keys,
      :firewall_on,
      :secured,
      :bios_date,
      :windows_ver,
      :chef_complete,
      :drive_status,
      :drive_speed,
      :computer_num,
      :computer_score,
      :user_policy_updated,
      :computer_policy_updated,
      :z2ls_version
    )
    backstage.insert_rows([ 
                          data[:computer_num],
                          data[:device_name], 
                          data[:company_name], 
                          0,
                          0,
                          data[:atera_id], 
                          data[:last_backup_date], 
                          data[:backups_started], 
                          data[:backups_completed], 
                          data[:backup_faileds], 
                          "", 
                          Time.zone.now, 
                          "", 
                          data[:hdd_keys],
                          data[:firewall_on],
                          data[:secured],
                          data[:bios_date],
                          data[:windows_ver],
                          data[:chef_complete],
                          data[:drive_status],
                          data[:drive_speed],
                          data[:computer_score],
                          data[:uesr_policy_updated],
                          data[:computer_policy_updated],
                          data[:z2ls_version]
    ])
    backstage.save
    
    #head :ok #Commented this out because jets uses rails 5
    render plain: "OK ", statsus: 200
    #format.any { render :json => {:response => 'OK' },:status => 200}

  end

end
