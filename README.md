# RedToken By ERC-721
  
ERC721 기반 p2p 용도.  
node, npm api 제공  
  
  
### 환경설정  
framework  
npm [npm Pages](https://www.npmjs.com/)  
truffle [truffleframework Pages](https://truffleframework.com/)  
  
  
**의존성**  
* sloc [solc Pages](https://www.npmjs.com/package/sloc/)  
* oepnzeppelin-solidity [oepnzeppelin-solidity Pages](https://github.com/OpenZeppelin/openzeppelin-solidity/)  
* web3 [web3js Pages](https://github.com/ethereum/web3.js/)  
* bignumber.js [bignumber.js Pages](https://github.com/MikeMcl/bignumber.js#readme/)  
* bn.js [bn.js Pages](https://github.com/indutny/bn.js/)  
* dotenv [dotenv Pages](https://github.com/motdotla/dotenv#readme/)  
* es6-promisify [es6-promisify Pages](https://github.com/digitaldesignlabs/es6-promisify#readme/)  
* ethereumjs-abi [ethereumjs-abi Pages](https://github.com/axic/ethereumjs-abi/)  
* ethereumjs-util [ethereumjs-util Pages](https://github.com/ethereumjs/ethereumjs-util/)  
* lodash [lodash Pages](https://lodash.com/)  
* request [request Pages](https://github.com/request/request#readme/)  
* solium [solium Pages](https://github.com/duaraghav8/Ethlint#readme/)  
* solium-plugin-dotta [solium-plugin-dotta Pages](https://github.com/cryppadotta/solium-plugin-dotta#readme/)  
* solium-plugin-zeppelin [solium-plugin-zeppelin Pages](https://github.com/elopio/solium-plugin-zeppelin#readme/)  
* truffle-hdwallet-provider [truffle-hdwallet-provider Pages](https://github.com/trufflesuite/truffle-hdwallet-provider#readme/)  
* tslint [tslint Pages](https://palantir.github.io/tslint/)  
* tslint-config-0xproject [tslint-config-0xproject Pages](https://www.npmjs.com/package/tslint-config-0xproject/)  
* 그 외 의존성은 패키지내 확인 할 것.  
  
  
**환경 구성방식**
  
- 설치 순서  
> 설치할 디렉토리 생성후 순차 실행  
  
1. truffle init  
2. npm init -y  
3. npm install solc  
4. npm install openzeppelin-solidity  
5. npm install web3 그외 의존성  
6. truffle create contract RedTokenBase 등  
7. migration 생성 외  
  
  
  
### REDToken contract 등록 및 초기 설정  
  
  
### REDToken 발행/token확인 방법  
> ropsten test net 계약 확인  
https://ropsten.etherscan.io/token/  
  
> metamask 개별 등록 한 후, 계정 생성 필요  
  
> testnet 이더 받기  
https://faucet.ropsten.be/   

> 각 확인 주소  
ropsten (https://ropsten.etherscan.io/address/0xc069e0394b549b3b17ee7750110b9d425e6a87d5#code)  
0xC069E0394B549b3B17ee7750110B9D425e6A87D5  
  
  
main net  
before version by red token (https://etherscan.io/address/0x175bb51e8476a8c740573269d048adfd4c68ec5a#code)  
0x175bB51E8476A8c740573269D048aDFd4c68Ec5A  
  
after version by red token (https://etherscan.io/address/0xe512cd0db34e774075bd7e034fb1e3dd96137177#code)  
0xe512cd0db34e774075bd7e034fb1e3dd96137177  
  
  