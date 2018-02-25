pragma solidity ^0.4.17;

import "../installed_contracts/zeppelin/contracts/ownership/Ownable.sol";

contract Payroll is Ownable {
  address oracleAddress;
  uint employeeCount;
  uint private currentBalance;
  uint private totalSalaries;
  
  struct Employee {
    address account;
    address[] allowedTokens;
    uint initialSalary;
    uint currentSalary;
  }

  mapping (uint=>Employee) private employees;

  mapping (address=>bool) private isEmployee;

  modifier onlyEmployee() {
    require(isEmployee[msg.sender]);
    _;
  }

  modifier onlyOracle() {
    require(msg.sender == oracleAddress);
    _;
  }

  function Payroll() public {
    currentBalance = 0;
    totalSalaries = 0;
  }

  /* OWNER ONLY */
  function addEmployee(address accountAddress, address[] allowedTokens, uint256 initialYearlyUSDSalary) public onlyOwner returns (uint employeeId) {
    require(!isEmployee[accountAddress]);
    employeeCount += 1;
    employees[employeeCount] = Employee(accountAddress, allowedTokens, initialYearlyUSDSalary, initialYearlyUSDSalary);
    isEmployee[accountAddress] = true;
    totalSalaries += initialYearlyUSDSalary;
    return employeeCount;
  }  

  function setEmployeeSalary(uint256 employeeId, uint256 yearlyUSDSalary) public onlyOwner {
    require(employees[employeeId].account != address(0));

    totalSalaries = totalSalaries - employees[employeeId].currentSalary + yearlyUSDSalary;
    employees[employeeId].currentSalary = yearlyUSDSalary;
  }

  function removeEmployee(uint256 employeeId) public onlyOwner {
    require(employees[employeeId].account != address(0));
    address accountAddress = employees[employeeId].account;
    require(isEmployee[accountAddress]);
    totalSalaries -= employees[employeeId].currentSalary;
    delete employees[employeeId];
    isEmployee[accountAddress] = false;

  }

  function addFunds() payable public onlyOwner {

  }

  function scapeHatch();
  // function addTokenFunds()? // Use approveAndCall or ERC223 tokenFallback

  function getEmployeeCount() constant  public onlyOwner returns (uint256) {
    return employeeCount;
  }

  function setOracle(address _oracleAddress) public onlyOwner {
    oracleAddress = _oracleAddress;
  }

  function getEmployee(uint256 employeeId) constant public returns (address employeeAddress, address[] allowedTokens,
     uint initialSalary, uint currentSalary ) {
    require(employees[employeeId].account != address(0));
    return (employees[employeeId].account,employees[employeeId].allowedTokens, employees[employeeId].initialSalary,
      employees[employeeId].currentSalary );
  }

  function calculatePayrollBurnrate() constant public onlyOwner returns (uint256) { // Monthly usd amount spent in salaries
    return totalSalaries / 12;
  }

  function calculatePayrollRunway() constant public onlyOwner returns (uint256) { // Days until the contract can run out of funds
    // this doesn't account for leap years, but is accurate enough for the runway calc
    return currentBalance / (totalSalaries / 365);
  }

  /* EMPLOYEE ONLY */
  function determineAllocation(address[] tokens, uint256[] distribution) public onlyEmployee { // only callable once every 6 months
    
  }
  
  function payday(); // only callable once a month

  /* ORACLE ONLY */
  function setExchangeRate(address token, uint256 usdExchangeRate) public onlyOracle { // uses decimals from token

  }

  function setEtherExchangeRate(uint256 usdExchangeRate) public onlyOracle { 

  }
}