module.exports.params = {
  Entries: [ 
    {
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
    },
    {
      // Event envelope fields
      Source: 'custom.myATMapp',
      EventBusName: 'default',
      DetailType: 'transaction',
      // Main event body
      Detail: JSON.stringify({
        account: '0000000000000000',
        time: '2023-12-30T05:01:20Z',
        action: 'withdrawal',
        location: 'NY-NYC-001',
        amount: 20,
        result: 'approved',
        transactionId: '123457',
        cardPresent: true,
        partnerBank: 'Example Bank',
        remainingFunds: 212.52
      })
    },
    {
      // Event envelope fields
      Source: 'custom.myATMapp',
      EventBusName: 'default',
      DetailType: 'transaction',
      // Main event body
      Detail: JSON.stringify({
        account: '0000000000000000',
        time: '2023-12-28T05:01:27Z',
        action: 'withdrawal',
        location: 'NY-NYC-002',
        amount: 60,
        result: 'denied',
        transactionId: '123458',
        cardPresent: true,
        remainingFunds: 5.77
      })
    }    
  ]
}