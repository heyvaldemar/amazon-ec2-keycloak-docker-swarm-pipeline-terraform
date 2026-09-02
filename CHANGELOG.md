# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_(no unreleased changes yet)_

## [1.0.0] - 2026-09-02

First semver release. Brings this configuration to the fleet standard.

### Fixed

- **`terraform validate` failed on a fresh clone**: the instance passed two template arguments built from a local that was never declared (the user_data template never used them). Removed.
- **Secret ARN defaults carried a real AWS account id**; replaced with the same placeholders the sibling repositories use.

### Changed

- `required_version` relaxed from an exact `1.9.2` pin (which rejected
  every other Terraform binary) to `>= 1.9.2, < 2.0.0`.
- AWS provider constraint moved to `~> 6.62.0`; personal domain
  defaults replaced with `example.com` placeholders.

### Added

- **`.terraform.lock.hcl`** locking every provider to exact builds and
  checksums for four platforms.
- **Terraform Verification workflow**: `fmt -check`, `init
  -lockfile=readonly`, `validate`, `tflint`, actionlint — on every push,
  pull request, and weekly.
- MIT `LICENSE`, `SECURITY.md`, and a README that says what gets
  created, what must be changed before the first apply, and what CI
  does and does not prove.

[Unreleased]: https://github.com/heyvaldemar/amazon-ec2-keycloak-docker-swarm-pipeline-terraform/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/heyvaldemar/amazon-ec2-keycloak-docker-swarm-pipeline-terraform/releases/tag/v1.0.0
