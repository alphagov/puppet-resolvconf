# resolvconf

Manage the `resolvconf` package and configurations on Debian-alike systems.

## Example usage

Include with default parameters:
```
include resolvconf
```

Pass in custom configuration:
```
class { 'resolvconf':
  nameservers => ['1.1.1.1', '2.2.2.2'],
}
```

Please see the class documentation for details of the support params.

## Running tests

Install dependencies:

```
bundle install
```

Run tests:

```
bundle exec rake test
```

## License

See [LICENSE](LICENSE) file.
