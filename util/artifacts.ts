export class Artifacts {
    public Migrations: any;
    public RedTokenCore: any;
    public RedTokenCoreTest: any;
    public RedTokenOwnership: any;
    public RedTokenBase: any;
    public RedTokenAccessControl: any;
    public ERC721: any;
    public SafeMath: any;
    public Address: any;
      
    public MockTokenReceiver: any;
  
    constructor(artifacts: any) {
      this.Migrations = artifacts.require('Migrations');
      this.RedTokenCore = artifacts.require('RedTokenCore');
      this.RedTokenCoreTest = artifacts.require('RedTokenCoreTest');
      this.RedTokenOwnership = artifacts.require('RedTokenOwnership');
      this.RedTokenBase = artifacts.require('RedTokenBase');
      this.RedTokenAccessControl = artifacts.require('RedTokenAccessControl');
      this.ERC721 = artifacts.require('ERC721');
      this.SafeMath = artifacts.require('SafeMath');
      this.Address = artifacts.require('Address');
  
      this.MockTokenReceiver = artifacts.require('MockTokenReceiver');
    }
  }
  