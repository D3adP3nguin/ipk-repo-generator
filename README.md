# IPK Repository Generator

This repository provides a set of scripts and a GitHub Actions workflow to generate and manage IPK repositories for OpenWRT devices. It automates the process of creating the `Packages`, `Packages.gz`, `Packages.manifest`, and `Packages.sig` files from a set of IPK packages.

## Usage

### Prerequisites

- GitHub account with access to create and manage repositories
- OpenWRT device

### Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/D3adP3nguin/ipk-repo-generator.git
    cd ipk-repo-generator
    ```

2. **Create and switch to your own branch:**

    ```sh
    git checkout -b your-branch-name
    ```

3. **Add your IPK files:**

    Place the IPK files you want to include in the repository inside the `IPK_files` directory.

### Running the Workflow

1. **Push changes to GitHub:**

    Commit and push your changes to your branch on the GitHub repository.

    ```sh
    git add .
    git commit -m "Add IPK files"
    git push origin your-branch-name
    ```

2. **GitHub Actions:**

    The GitHub Actions workflow will automatically run and generate the repository files. The generated files will be available as artifacts in the workflow run.

### Manual Script Execution

If you want to run the scripts manually on your local machine:

1. **Generate Packages file:**

    ```sh
    chmod +x ./scripts/generate_packages.sh
    ./scripts/generate_packages.sh <device> <fw> <flavor> <category>
    ```

2. **Compress Packages file:**

    ```sh
    chmod +x ./scripts/compress_packages.sh
    ./scripts/compress_packages.sh <device> <fw> <flavor> <category>
    ```

3. **Generate Packages.manifest file:**

    ```sh
    chmod +x ./scripts/generate_manifest.sh
    ./scripts/generate_manifest.sh <device> <fw> <flavor> <category>
    ```

4. **Sign the Packages file:**

    ```sh
    chmod +x ./scripts/sign_packages.sh
    ./scripts/sign_packages.sh <device> <fw> <flavor> <category>
    ```

5. **Upload to S3 (Optional):**

    If you want to upload the generated files to an S3 bucket, you can uncomment the lines in the GitHub Actions workflow and set up the necessary environment variables:

    ```sh
    export AWS_ACCESS_KEY_ID=your_access_key
    export AWS_SECRET_ACCESS_KEY=your_secret_key
    export AWS_REGION=your_region
    export bucket_name=your_s3_bucket_name

    chmod +x ./scripts/upload_to_s3.sh
    ./scripts/upload_to_s3.sh
    ```

6. **Setup Repository:**

    ```sh
    chmod +x ./scripts/repo_setup.sh
    ./scripts/repo_setup.sh <device> <fw> <flavor> <category>
    ```

### Merging Changes

1. **Create a Pull Request:**

    Once you have completed your changes and pushed them to your branch, create a pull request on GitHub to merge your changes into the `main` branch.

## Notes

- Ensure that all scripts have the appropriate execute permissions (`chmod +x script.sh`).
- The repository structure and file paths should be adjusted according to your specific needs.
- Use detailed commit messages to describe the changes made.
- Refer to the [GitHub Wiki](https://github.com/D3adP3nguin/ipk-repo-generator/wiki) for detailed documentation on each script and the GitHub Actions workflow.
