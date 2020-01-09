# ECS Mapper

## Synopsis

This tool turns a mapping CSV to roughly equivalent pipelines for:

- Beats
- Elasticsearch
- Logstash

The goal of this tool is to generate starter pipelines of each flavor, to
help you get started quickly on you map your event sources to ECS.

A "mapping CSV" is what you get, when you start planning how to map an event source to ECS.

Colleagues may collaborate on a spreadsheet that looks like this:

| source\_field | destination\_field | notes  |
|--------------|-------------------|---------------------------------------|
| duration     | event.duration    | ECS has this as nanoseconds           |
| remoteip     | source.ip         | Hey @Jane do you agree with this one? |
| message      |                   | No need to change this field          |
| ...          |                   |                                       |

You can export your spreadsheet to CSV, run it through the ECS mapper,
and get your starter pipelines generated.

Note that this tool generates partial pipelines, that only do the rename/copy
operations and some field format adjustments. It's up to you to integrate them
in a complete pipeline that ingests and outputs the data however you need.

Scroll down to the [Examples](#examples) section below, to get right to the good stuff.

## Maturity

This code is a proof of concept and is not officially supported at this time.
The pipelines generated by this tool are not meant to be complete nor production-ready.
They are simply meant to give you a head start in mapping your various sources to ECS.

## CSV Format

Here's a bit more details on the CSV format used by this tool. Since mapping
spreadsheets are primarily used by humans, it's totally fine to have as many columns
as you need in your spreadsheets/CSV. Only the following columns will be considered.

| column name | required | allowed values | notes |
|-------------|----------|----------------|-------|
| source\_field | required |  | A dotted Elasticsearch field name. Dots represent JSON nesting. |
| destination\_field | required |  | A dotted Elasticsearch field name. Dots represent JSON nesting. Can be left empty if there's no rename (just a type conversion). |
| rename | optional | rename, copy, (empty) | What to do with the field. If left empty, default action is based on the `--rename-action` flag. |
| format\_action | optional | to\_float, to\_integer, to\_string, to\_boolean, to\_array, uppercase, lowercase, (empty) | Simple conversion to apply to the field value. |

## Usage and Dependencies

This is a simple Ruby program with no external dependencies, other than development
dependencies.

Any modern version of Ruby should be sufficient. If you don't intend to run the
tests or the rake jobs, you can skip right to [usage tips](#using-the-ecs-mapper).

### Ruby Setup

If you want to tweak the code of this script, run the tests or use the rake tasks,
you'll need to install the development dependencies.

Once you have Ruby installed for your platform, installing the dependencies is simply:

```bash
gem install bundler
bundle install
```

Run the tests:

```bash
rake test
```

### Using the ECS Mapper

Help.

```bash
./map --help
```

Process my.csv and output pipelines in the same directory as the csv.

```bash
./map --file my.csv
```

Process my.csv and output pipelines elsewhere.

```bash
./map --file my.csv --output pipelines/mine/
```

Process my.csv, fields with an empty value in the "rename" column are copied,
instead of renamed (the default).

```bash
./map --file my.csv --rename copy
```

## Examples

Look at an example CSV mapping and the partial pipelines generated from it:

- [example/mapping.csv](example/mapping.csv)
- [example/beats.yml](example/beats.yml)
- [example/elasticsearch.json](example/elasticsearch.json)
- [example/logstash.conf](example/logstash.conf)

You can try each sample pipeline easily by following the instructions
in [example/README.md](example/).
