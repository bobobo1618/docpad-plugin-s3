# Notice

This project has been deprecated by my [Sunny plugin](https://github.com/bobobo1618/docpad-plugin-sunny). Go there. It's better in all ways.

# Docpad S3

So this is one of the only useful things I've published, yay! Actually distributing my projects is new to me.

Basically, after your [Docpad](https://github.com/bevry/docpad) installation finishes generating the static documents, this plugin is meant to upload them all to Amazon S3.

## Installation

In your Docpad site directory:

- Temporary: `npm install docpad-plugin-s3`
- Permanent: `npm install --save docpad-plugin-s3` (should write the dependency to package.json)

## Configuration

There are 3 environment variables that must be configured:

- `DOCPAD_S3_KEY`: AWS access key
- `DOCPAD_S3_SECRET`: AWS access secret
- `DOCPAD_S3_BUCKET`: S3 bucket to store the generated files in.

## Running

Generated files will be added to S3 whenever Docpad runs the generate hook.

## Known bugs

- Docpad crashes when the environment variables aren't set.
- Uploads have issues (incorrect hashes sent to Amazon I think)
