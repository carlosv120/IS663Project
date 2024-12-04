import React, { useState, useEffect } from "react"; // Import useState and useEffect
import logo from "./logo.svg";
import "./App.css";

function App() {
  const [message, setMessage] = useState("Loading..."); // Initialize state with "Loading..."

  useEffect(() => {
    // Fetch data from the server API
    fetch("/api/test/ping") // Proxy in package.json will forward to the server
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Network response was not ok (${response.statusText})`);
        }
        return response.text(); // Parse response as plain text
      })
      .then((data) => setMessage(data)) // Append "Pong: " to the server's response
      .catch((error) => setMessage(`Error: ${error.message}`)); // Handle errors gracefully
  }, []); // Dependency array ensures useEffect runs only once

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>React-ASP.NET Core Connection Test</h1>
        <p>Server Response: {message}</p> {/* Display the server's response */}
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
