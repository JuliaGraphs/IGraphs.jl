## Project Overview

IGraphs.jl is a thin Julia wrapper around the C graphs library [`igraph`](https://igraph.org/). The package provides:

- **Wrapper types**: Most C types (like `igraph_vector_int_t`) are directly available in `IGraphs.LibIGraph` and also have Julian wrappers (like `IGVectorInt`)
- **High-level Julian interfaces**: The Julian `IGraph` wrapper follows the `Graphs.jl` interface, while `IGVector*` and `IGMatrix*` follow the Julia array interface
- **Alternatives to Graphs.jl algorithms**: Some functions have new methods that dispatch to igraph C library implementations using the `IGraphAlg` type
- **Raw C bindings**: Available in `IGraphs.LibIGraph` namespace
- **Low-level Julian bindings**: Higher-level wrappers with error handling and type conversions

### Version Compatibility
IGraphs.jl v`X.Y.Z` wraps igraph C library v`x.y.z` where `X=x` and `Y=y`. The patch versions `Z` and `z` might not match.

## Development Commands

### Instantiate Environment
```bash
# Package
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

### Running Tests
```bash
# Run default tests
julia --project=. -e "using Pkg; Pkg.test()"
```

Do not try to run single test files.

### Package Management
```bash
# Instantiate project dependencies
julia --project=. -e "using Pkg; Pkg.instantiate()"

# Update dependencies
julia --project=. -e "using Pkg; Pkg.update()"

# Check package status
julia --project=. -e "using Pkg; Pkg.status()"
```

Do not read the Manifest.jl files -- they are machine generated and should not be manipulated directly.

## Code Formatting

### Removing Trailing Whitespaces
Before committing, ensure there are no trailing whitespaces in Julia files:

```bash
# Remove trailing whitespaces from all .jl files (requires gnu tools)
find . -type f -name '*.jl' -exec sed --in-place 's/[[:space:]]\+$//' {} \+
```

### Ensuring Files End with Newlines
Ensure all Julia files end with a newline to avoid misbehaving CLI tools:

```bash
# Add newline to end of all .jl files that don't have one
find . -type f -name '*.jl' -exec sed -i '$a\' {} \+
```

### General Formatting Guidelines
- Use 4 spaces for indentation (no tabs)
- Remove trailing whitespaces from all lines
- Ensure files end with a single newline
- Follow Julia standard naming conventions
- Keep lines under 100 characters when reasonable

## Contributing

It is a good idea to keep two remotes - an `upstream` remote treated as a source of truth, and a personal `origin` remote on your own github account for storing branches and preparing pull requests. Pull requests can be managed with `gh`.

This package follows standard Julia development practices:
- **Always pull latest changes first**: Before creating any new feature or starting work, ensure you have the latest version by running `git pull upstream master` (or `git pull upstream main`)
- **Pull before continuing work**: Other maintainers might have modified the branch you are working on. Always call `git pull` before continuing work on an existing branch
- **Push changes to remote**: Always push your local changes to the remote branch to keep the PR up to date: `git push origin <branch-name>`
- **Run all tests before submitting**: Before creating or updating a PR, always run the full test suite to ensure nothing is broken: `julia --project=. -e "using Pkg; Pkg.test()"`
- Fork and create feature branches
- Write tests for new functionality
- Ensure all tests pass before merging
- **Keep PRs focused**: A PR should implement one self-contained change. Avoid mixing feature work with formatting changes to unrelated files, even for improvements like adding missing newlines. Format unrelated files in separate commits or PRs.

## Creating Pull Requests

When creating pull requests to solve GitHub issues:

1. **Setup remotes properly**: Make sure you have both `origin` (your fork) and `upstream` (main repository) remotes configured:
   ```bash
   git remote add upstream https://github.com/JuliaGraphs/IGraphs.jl.git
   git remote add origin https://github.com/YOUR_USERNAME/IGraphs.jl.git
   ```

2. **Create feature branch**: Always create a feature branch from the latest upstream master:
   ```bash
   git checkout master
   git pull upstream master
   git checkout -b descriptive-branch-name
   ```

3. **Make your changes**: Implement the solution, add tests, and ensure all tests pass:
   ```bash
   julia --project=. -e "using Pkg; Pkg.test()"
   ```

4. **Commit and push**: Commit your changes and push to your fork:
   ```bash
   git add .
   git commit -m "Descriptive commit message"
   git push -u origin your-branch-name
   ```

5. **Create PR using gh CLI**: Use the GitHub CLI to create the pull request:
   ```bash
   gh pr create --title "Your PR Title" --body "Description of changes" --repo JuliaGraphs/IGraphs.jl
   ```

This workflow ensures your PR targets the main repository from your personal fork.
