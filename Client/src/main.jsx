/**
 * main.jsx
 * CS348 Project – React Application Entry Point
 *
 * This file initializes the React application by:
 *  - Importing global Bootstrap styling
 *  - Rendering the root <App /> component into the DOM
 *  - Setting up the application’s top-level React structure
 *
 * All client-side UI logic begins execution from this entry point.
 */

import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import 'bootstrap/dist/css/bootstrap.min.css'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
