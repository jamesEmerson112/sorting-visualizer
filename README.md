# Sort visualizer

This React project is designed to visualize each sorting process. Then the project will be dockerized and installed to an AWS EC2 instance with Terraform.


# Get started with local server
- install node js on your machine
- cd to root directory, type "npm install" for dependencies
- type "npm start" to start the server
- Go to http://localhost:8080

# Get started with Docker, Terraform, and AWS
## Prerequisites
1. AWS account
2. AWS CLI
3. Docker and dockerhub account
4. Terraform

## Step 1 - configure AWS CLI
1. Go to Services, then click on IAM -> User -> Add a user
2. Type in a Username, then select Programmatic acces for AWS
3. Create an user group with Administrator Access -> Download.csv
4. ### `aws configure`
add Access Key ID and Seceret Access Key as asprompted, then choose a preferred AWS region

## Step 2 - dockerize the app
1. Create a Docker file and add the following lines:
### `FROM node:16.13.0`

### `LABEL version="1.0"`

### `LABEL description="This is the base docker image for my React app"`

### `LABEL maintainer="yourEmail@mail.com"`

### `WORKDIR /usr/src/app`

### `COPY ["package.json", "package-lock.json", "./"]`

### `RUN npm install`

### `COPY . .`

### `EXPOSE 8080`

### `CMD ["npm", "start"]`

Here is an overview of the commands:

FROM defines the node version that we use for our container

LABEL indicates the version

WORKDIR sets the working directory for the app

COPY is used to copy files from one destination to another, and the last parameter is the destination to copy the files

RUN defines the command to be run by Docker. I tend to use npm, but commonly yarn is used

EXPOSE tells docker which port it should listen

CMD defines the command to start the container

2. ### `docker build -t <image-name> .` 
- this builds the image

3. ### `docker run -it -p 8080:8080 <image-name>`
- then go to http://localhost:8080 on your browser to view the app
4. Push the repo to docker

## Step 3 - Provision the server using terraform
My Terraform does 9 steps in general:
1. Create vpc
2. Create Internet Gateway
3. Create Custom Route Table
4. Create a subnet 
5. Associate subnet with Route Table
6. Create Security Group to allow port 22,80,443
7. Create a network interface with an ip in the subnet that was created in step 4
8. Assign an elastic IP to the network interface created in step 7
9. Create Ubuntu server and install/enable apache2



project
1. ansible   -> provision_frontend.yaml
2. react-app -> src + package.json + dockerfile
3. terraform -> frontend -> main.tfw
4 .gitignore
5. README.md


# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can't go back!**

If you aren't satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you're on your own.

You don't have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn't feel obligated to use this feature. However we understand that this tool wouldn't be useful if you couldn't customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: [https://facebook.github.io/create-react-app/docs/code-splitting](https://facebook.github.io/create-react-app/docs/code-splitting)

### Analyzing the Bundle Size

This section has moved here: [https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size](https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size)

### Making a Progressive Web App

This section has moved here: [https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app](https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app)

### Advanced Configuration

This section has moved here: [https://facebook.github.io/create-react-app/docs/advanced-configuration](https://facebook.github.io/create-react-app/docs/advanced-configuration)

### Deployment

This section has moved here: [https://facebook.github.io/create-react-app/docs/deployment](https://facebook.github.io/create-react-app/docs/deployment)

### `npm run build` fails to minify

This section has moved here: [https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify](https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify)
