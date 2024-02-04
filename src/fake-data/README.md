# Generate ATM Transaction Data using Faker

This code generates fake data using [Faker](https://fakerjs.dev/). The data is used to simulate ATM transactions.

## Steps to Run:
1. Create a directory and use it as the working directory:
    ```bash
    mkdir fake-data
    cd fake-data
    ```
3. Create a new Node project: 
    ``` bash
    npm init -y
    ```
3. Download [Faker](https://fakerjs.dev/) to generate the data and esbuild-register to run Typescript code from Node.js
    ``` bash
    npm install --save-dev  @faker-js/faker esbuild-register
    ```
4. Create a file called `fake-user-data.ts` and add the following code:
    ```typescript
    import { faker } from '@faker-js/faker';


    interface UserD {
        name: string;
        email: string;
    }

    function createRandomUser(): UserD {
        const randomName = faker.person.fullName();
        const randomEmail = faker.internet.email();

        return {
            name: randomName,
            email: randomEmail,
        };
    }


    const user = createRandomUser();

    console.log(user);
    ```
5. Run the code using:
    ```bash
    node -r esbuild-register fake-user-data.ts
    ```
6. A fake name and email is printed to the console 
    `{ name: 'Bob Herman', email: 'Wava18@hotmail.com' }`

    
