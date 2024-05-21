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
    cd repo
    ```

2. **Add your IPK files:**

    Place the IPK files you want to include in the repository inside the `IPK_files` directory.

3. **Set up GitHub Secrets:**

    - `USIGN_PRIVATE_KEY`: The private key used to sign the Packages file.

### Running the Workflow

1. **Push changes to GitHub:**

    Commit and push your changes to the GitHub repository.

    ```sh
    git add .
    git commit -m "Add IPK files and setup repository"
    git push origin main
    ```

2. **GitHub Actions:**

    The GitHub Actions workflow will automatically run and generate the repository files. The generated files will be available as artifacts in the workflow run.

### Manual Script Execution

If you want to run the scripts manually on your local machine:

1. **Generate Packages file:**

    ```sh
    chmod +x ./scripts/generate_packages.sh
    ./scripts/generate_packages.sh
    ```

2. **Compress Packages file:**

    ```sh
    chmod +x ./scripts/compress_packages.sh
    ./scripts/compress_packages.sh
    ```

3. **Generate Packages.manifest file:**

    ```sh
    chmod +x ./scripts/generate_manifest.sh
    ./scripts/generate_manifest.sh
    ```

4. **Sign the Packages file:**

    ```sh
    chmod +x ./scripts/sign_packages.sh
    ./scripts/sign_packages.sh ./output/Packages ./output/Packages.sig "$USIGN_PRIVATE_KEY" ./repo/usign/build/usign
    ```

5. **Copy IPK files to output directory:**

    ```sh
    cp ./repo/IPK_files/*.ipk ./output/
    ```

## Notes

- Ensure that all scripts have the appropriate execute permissions (`chmod +x script.sh`).
- The `USIGN_PRIVATE_KEY` should be securely managed and not exposed publicly.
- The repository structure and file paths should be adjusted according to your specific needs.

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
