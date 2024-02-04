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

