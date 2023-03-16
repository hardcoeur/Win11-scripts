# TOCK takes a markdown formatted table of contents with links and outputs hash style headers with their associated url to an unordered list on the console.

# Get the file path as an argument
$filePath = $args[0]

# Read the file content
$fileContent = Get-Content $filePath

# Initialize an array to store the table of contents
$tableOfContents = @()

# Loop through each line in the file
foreach ($line in $fileContent) {
    # Check if the line is a hash style header
    if ($line -match "^#{1,6}\s+(.+)$") {
        # Extract the header level and value
        $headerLevel = $matches[0].Length
        $headerValue = $matches[1]

        # Check if the header value contains a URL
        if ($headerValue -match "\[(.*)\]\((.*)\)$") {
            $headerValue = $matches[1]
            $headerUrl = $matches[2]
        } else {
            $headerUrl = $null
        }

        # Add the header to the table of contents array
        $tableOfContents += [PSCustomObject]@{
            Level = $headerLevel
            Value = $headerValue
            Url = $headerUrl
        }
    }
}

# Display the table of contents as a list, with the header value and URL (if it exists) on the same line
foreach ($header in $tableOfContents) {
    $line = ('#' * $header.Level) + ' ' + $header.Value
    if ($header.Url) {
        $line += ' (' + $header.Url + ')'
    }
    Write-Output $line
}
