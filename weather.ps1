# Replace everything after the "=" with your OpenWeatherMap API Key
$apiKey = Get-Content "API_KEY"

# Insert your zip code here
$zipCode = '10001'

# Define Weather Emoji
$emojis = @{
    "clear sky"        = "☀️";
    "few clouds"       = "🌤️";
    "scattered clouds" = "🌥️";
    "broken clouds"    = "☁️";
    "shower rain"      = "🌦️";
    "rain"             = "🌧️";
    "thunderstorm"     = "⛈️";
    "snow"             = "❄️";
    "mist"             = "🌫️";
}

# Define Wind Directions
$windDirectionMap = @{
    0   = "N";
    45  = "NE";
    90  = "E";
    135 = "SE";
    180 = "S";
    225 = "SW";
    270 = "W";
    315 = "NW";
    360 = "N";
}

# API URL
$apiUrl = "http://api.openweathermap.org/data/2.5/weather?zip=$zipCode&appid=$apiKey"

# Submit API Request
$response = Invoke-RestMethod -Uri $apiUrl

# Extract weather information
$temperature = $response.main.temp
$windSpeed = $response.wind.speed
$windDirection = $response.wind.deg
$weatherDescription = $response.weather[0].description
$city = $response.name

# Convert temperature from Kelvin to Fahrenheit
$temperature = [math]::Round(($temperature - 273.15) * 9/5 + 32)

# Convert wind speed from meters per second to MPH
$windSpeed = [math]::Round($windSpeed * 2.23694, 1)

# Select the wind direction
$windDirection = $windDirectionMap.Keys | Where-Object { $_ -le $windDirection } | Sort-Object -Descending | Select-Object -First 1 | ForEach-Object { $windDirectionMap[$_] }

# Select the appropriate weather emoji
$emoji = $emojis[$weatherDescription]

# Output the weather information to the terminal
Write-Host "Current Weather for $city"
Write-Host "Temperature: $temperature°F"
Write-Host "Wind: $windSpeed MPH $windDirection"
Write-Host "Current Conditions: $weatherDescription $emoji"