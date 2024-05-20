# My Static Website

This project is a static website hosted on AWS S3 using Terraform for deployment.

## Structure

- `src/`: Contains the HTML and CSS files for the website.
- `terraform/`: Contains the Terraform configuration files.
- `.gitignore`: Specifies files to be ignored by Git.
- `README.md`: This file.

## Deployment

To deploy this website to AWS S3, follow these steps:

1. Initialize Terraform:
    ```sh
    terraform init
    ```

2. Apply the Terraform configuration:
    ```sh
    terraform apply
    ```
   Confirm the action when prompted by typing `yes`.

3. The website will be available at the S3 bucket's website endpoint, which will be displayed in the output.
