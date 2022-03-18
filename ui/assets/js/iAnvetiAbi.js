iAnvetiAbi = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_ref",
				"type": "uint256"
			}
		],
		"name": "deleteDocument",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_deleted",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_ref",
				"type": "uint256"
			}
		],
		"name": "findDocument",
		"outputs": [
			{
				"internalType": "string",
				"name": "_ipfsHash",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getDocumentCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_ref",
				"type": "uint256"
			}
		],
		"name": "getDocumentEarnings",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_earnings",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getEarnings",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_earnings",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPaymentCurrency",
		"outputs": [
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPremiumSearchPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_retrievePrice",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_ref",
				"type": "uint256"
			}
		],
		"name": "getViewPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_viewPrice",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_term",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_fee",
				"type": "uint256"
			}
		],
		"name": "premiumSearch",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "_ref",
				"type": "uint256[]"
			},
			{
				"internalType": "string[]",
				"name": "_title",
				"type": "string[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_uploadDate",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_viewPrice",
				"type": "uint256[]"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_term",
				"type": "string"
			}
		],
		"name": "search",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "_ref",
				"type": "uint256[]"
			},
			{
				"internalType": "string[]",
				"name": "_title",
				"type": "string[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_uploadDate",
				"type": "uint256[]"
			},
			{
				"internalType": "string[]",
				"name": "_ipfsHash",
				"type": "string[]"
			},
			{
				"internalType": "uint256",
				"name": "_availableDocuments",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_title",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ipfsHash",
				"type": "string"
			},
			{
				"internalType": "string[]",
				"name": "_terms",
				"type": "string[]"
			},
			{
				"internalType": "uint256",
				"name": "_viewPrice",
				"type": "uint256"
			}
		],
		"name": "uploadDocument",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_ref",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_ref",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_viewPrice",
				"type": "uint256"
			}
		],
		"name": "viewDocument",
		"outputs": [
			{
				"internalType": "string",
				"name": "_ipfsHash",
				"type": "string"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "withdrawEarnings",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_earnings",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]