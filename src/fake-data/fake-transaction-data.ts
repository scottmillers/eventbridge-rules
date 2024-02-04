import { faker } from '@faker-js/faker';
import type { FinanceModule, StringModule } from '@faker-js/faker';

/*
// Event envelope fields
      Source: 'custom.myATMapp',
      EventBusName: 'default',
      DetailType: 'transaction',
      // Main event body
      Detail: JSON.stringify({
        account: '9999999999999999',
        time: '2023-12-27T05:01:42Z',
        action: 'withdrawal',
        location: 'MA-BOS-01',
        amount: 300,
        result: 'approved',
        transactionId: '123456',
        cardPresent: true,
        partnerBank: 'Example Bank',
        remainingFunds: 722.34
      })
*/
type Actions = 'withdraw' | 'deposit';
type Locations = 'MA-BOS-01' | 'NY-NYC-001' | 'NY-NYC-001';
type Results = 'approved' | 'denied';
type PartnerBank = 'Bank of America' | 'Wells Fargo';

interface Transaction {
    transactionId: StringModule["uuid"];
    time: Date;
    action: Actions;
    location: Locations;
    account: FinanceModule["accountNumber"];
    amount: FinanceModule["amount"];
    result: Results;
    cardPresent: Boolean;
    partnerBank: PartnerBank;
    remainingFunds: FinanceModule["amount"];
}

function createRandomTransaction(): Transaction {
    return {
        transactionId: faker.string.uuid(),
        time: faker.date.between({ from: '2020-01-01T00:00:00.000Z', to: '2024-01-01T00:00:00.000Z' }),
        action: faker.helpers.arrayElement(['withdraw', 'deposit']),
        location: faker.helpers.arrayElement(['MA-BOS-01', 'NY-NYC-001', 'NY-NYC-001']),
        account: faker.finance.accountNumber(8),
        amount: faker.finance.amount({ min: 5, max: 300, dec: 2 }),
        results: faker.helpers.arrayElement(['approved', 'denied']),
        cardPresent: faker.datatype.boolean(.9),
        partnerBank: faker.helpers.arrayElement(['Bank of America', 'Wells Fargo']),
        remainingFunds: faker.finance.amount({ min: 300, max: 5000, dec: 2 }),
    };
}



const atm = createRandomTransaction();

console.log(atm);
