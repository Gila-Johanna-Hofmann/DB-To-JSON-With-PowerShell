# initialize variables
$dataSource="SERVER_NAME"
$database="DATABASE_NAME"
$query = “SELECT COLUMN1, COLUMN2 FROM DATABASE_NAME”

# Initialize a conntection string
# Integrated Security=True is for Windows Authentication
$connectionString = “Server=$dataSource;Database=$database;Integrated Security=True;”

# Initialize the connection to the Db using the SqlClient class
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

# Open the connection
$connection.Open()

# Create a command and set its properties
# the command takes the query as a parameter
$command = $connection.CreateCommand()
$command.CommandText = $query

# Initialize a DataReader Object by telling the command to execute the query
# the DataReader is a forward-only stream of rows that can read from the DataSet that the command returns
$reader = $command.ExecuteReader()

# Loop through the rows and do something with the data
# reader.Read() is true until there are no more rows to read
while ($reader.Read()) {
    # add the data from each row to a hashtable; the integer indicates the column
    $results += @{$($reader.GetValue(1))=$($reader.GetValue(0))} 
}

# convert the hashtable to json
# this writes to console; if PS should write to file, add | Out-File "PATH\FILE_NAME.json"
$results | ConvertTo-Json -depth 100 

#don't forget to close the connection
$reader.Close()
