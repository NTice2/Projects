const apiKey = "374dc2d531bad6fa10bfe556ffc237bd";
const searchBtn = document.getElementById("searchBtn");
const cityInput = document.getElementById("cityInput");
const weatherInfo = document.getElementById("weatherInfo");

async function getWeather(city) {
    try {   // try to fetch the data
        const response = await fetch(`https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}`);
    if (!response.ok) {     //error handling
        throw new Error("City not found, Try Again!");
    }
    const info = await response.json();     //create json 'info' object populated with the data
    
    displayWeather(info);
    } catch (error) {       //error handling
        weatherInfo.innerHTML = error;
    }
}

function displayWeather(info) {
    const {name, main, weather} = info;    //destructure the info object into weather properties
    const tempF = ((main.temp - 273.15) * 1.8 + 32).toFixed(1) ;   //convert temperature from Kelvin to Fahrenheit and round to 1 decimal place
    weatherInfo.innerHTML = `
        <h2>${name}</h2>
        <p>Temperature: ${tempF}°F</p>
        <p>Humidity: ${main.humidity}%</p>
        <p>Condition: ${weather[0].description}</p>`;
}

searchBtn.addEventListener("click", () => {
    getWeather(cityInput.value);
});


