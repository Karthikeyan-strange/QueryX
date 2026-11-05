import React from 'react'
import ReactDOM from 'react-dom/client'
import 'leaflet/dist/leaflet.css'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import CustomerPortal from './pages/CustomerPortal'
import './styles.css'
import './dashboard.css'
import './customer-portal.css'
import './theme.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    {window.location.pathname === '/agent' ? <DashboardPage /> : window.location.pathname === '/customer' ? <CustomerPortal /> : <LoginPage />}
  </React.StrictMode>,
)
