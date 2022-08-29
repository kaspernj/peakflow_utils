# PeakflowUtils

Various tools to use with www.peakflow.io.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "peak_flow_utils"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install peak_flow_utils
```

Add this to `config/peakflow.rb`:
```ruby
PeakFlowUtils::Notifier.configure(auth_token: "your-token")
```

## Usage

### Reporting errors manually

```ruby
PeakFlowUtils::Notifier.notify(error: error)
```

### Reporting Rails errors

Add this to `config/peakflow.rb`:
```ruby
PeakFlowUtils::NotifierRails.configure
```

### Reporting ActiveJob errors in Rails:

If you want the job name and its arguments logged in parameters you can execute this service:
```ruby
PeakFlowUtils::ActiveJobParametersLogging.execute!
```

### Reporting Sidekiq errors in Rails:

Add this to `config/peakflow.rb`:
```ruby
PeakFlowUtils::NotifierSidekiq.configure
```

If you want the job name and its arguments logged in parameters you can execute this service:
```ruby
PeakFlowUtils::SidekiqParametersLogging.execute!
```

### Sidekiq and Postgres pings

Add this to `routes.rb`:
```ruby
Rails.application.routes.draw do
  mount PeakFlowUtils::Engine => "/peakflow_utils"
```

Add these to .env variables:
```
PEAKFLOW_PINGS_USERNAME=username
PEAKFLOW_PINGS_PASSWORD=secret-password
```

You can now add a HTTP ping on this path:
`/peakflow_utils/pings/sidekiq`

And this for Postgres:
`/pings/postgres_connections`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
