# MeteoFeel - Domain Document

## Overview
MeteoFeel is a health tracking application designed to help meteopaths (people sensitive to weather changes) monitor and understand the relationship between weather conditions and their well-being. The app combines weather data with personal health tracking to provide insights and alerts about potential health impacts.

## Core Domain Concepts

### User
- A person using the app to track their weather-related health conditions
- Has a profile with basic information and location
- Selects health issues they want to monitor
- Can record daily health status

### Weather Data
- Atmospheric conditions that may affect user's health
- Includes temperature, pressure, humidity, wind speed, and other relevant metrics
- Sourced from public weather services
- Three forecasts per day (morning/afternoon/evening)

### Health Status
- User's daily self-reported condition
- Includes:
  - Overall well-being rating
  - Health issues experienced
  - Time periods when issues occurred (morning/afternoon/evening)
- Recorded once per day
- Combined with weather forecasts in health records

### Health Alert
- Warning system based on:
  - Current weather conditions
  - User's selected health issues
  - Known weather-health correlations
  - Risk level assessment

## Core Features

### Weather Monitoring
- Weather forecast display (3 times per day)
- Historical weather data
- Weather change notifications

### Health Tracking
- Daily health status logging
- Health issue tracking
- Health history visualization
- Weather-health correlation analysis

### Analysis & Insights
- Correlation between weather and health
- Pattern recognition
- Historical trend analysis
- Health record analysis

### Alerts & Notifications
- Weather-based health warnings
- Personalized health alerts
- Preventive recommendations

## Limitations & Constraints
- Weather data accuracy
- User input reliability
- Medical disclaimer requirements
- Data privacy regulations 