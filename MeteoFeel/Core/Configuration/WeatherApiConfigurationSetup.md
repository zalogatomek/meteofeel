# API Configuration Setup

This directory contains the weather API configuration. The API key should not be committed to the repository.

## Setup Instructions

1. Get your Weather API key from [weatherapi.com](https://weatherapi.com)
2. Replace `YOUR_API_KEY_HERE` in `WeatherApiConfiguration.swift` with your actual API key
3. **Important**: Use git's `assume-unchanged` to prevent accidental commits

#### Using git assume-unchanged

After setting up your API key locally, run:

```bash
git update-index --assume-unchanged MeteoFeel/Core/Configuration/WeatherApiConfiguration.swift
```

This tells git to ignore any changes to this file, so your real API key won't be accidentally committed.

**To re-enable tracking (if you need to update the placeholder):**
```bash
git update-index --no-assume-unchanged MeteoFeel/Core/Configuration/WeatherApiConfiguration.swift
```

**To check if a file is assume-unchanged:**
```bash
git ls-files -v | grep "^[a-z]"
```
Files starting with lowercase letters are assume-unchanged.
