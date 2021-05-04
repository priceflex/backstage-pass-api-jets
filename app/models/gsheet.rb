# GSheet.new("Sheet Name")
#backstage = GSheet.new("Backstage App", "Devices")
#backstage.unique_cells("Device Name")
#backstage.insert_rows(["GlenFrey-PC","Tech Rockstars", "123", "12", "2312"])
#backstage.save

#backstage.update_cell("Device Name","GlenFrey-PC", "Backup", "0.80")
#backstage.save



class Gsheet

def initialize(sheet_name, worksheet_name=nil)
  @session = GoogleDrive::Session.from_service_account_key("config/client_secret.json")
  @spreadsheet = @session.spreadsheet_by_title("Backstage App")
  @unique_cells = []

  if worksheet_name
    @worksheet = @spreadsheet.worksheet_by_title(worksheet_name)
  else
    @worksheet = @spreadsheet.worksheets.first
  end
  @headers = @worksheet.rows.first

end

def worksheet
  @worksheet
end

def insert_rows(column_data)
  unless check_for_duplicate(column_data)
    # if no duplicates are found then add
    @worksheet.insert_rows(@worksheet.num_rows + 1, [column_data])
  else
    # TODO: find the row and replace the data
    index_to_update = @worksheet.rows.map {|a| a.first}.index(column_data.first)
    @worksheet.update_cells(index_to_update+1,1,[column_data])
    return false
  end
end

def unique_cells(cells)
  @unique_cells << cells
  @unique_cells.flatten!
end

def check_for_duplicate(array_to_check)
  trigger = false
  @unique_cells.map{ |a| @headers.find_index(a) }.each do |column|
  if !@worksheet.rows.transpose[column].select{|a| a == array_to_check[column] }.empty?
    trigger = true
  end
  end
  return trigger
rescue => e
binding.pry
  
end


def update_cell(search_column_name,search, column_name, column_values)

if cell_exists?(search_column_name,search)
  column_id = @headers.find_index(search_column_name)
  select_row = @worksheet.rows.select{|a| a[column_id] == search}.first
  find_row_index = @worksheet.rows.find_index {|a| a == select_row} + 1
  replace_column_id =  @headers.find_index(column_name) + 1
  @worksheet[find_row_index, replace_column_id] = column_values
end
  
end

def save

@worksheet.save

end

def cell_exists?(column, search)
 column_id = @headers.find_index(column)
 !@worksheet.rows.transpose[column_id].select{|a| a == search}.empty?
end

def headers
  @headers
end

end
