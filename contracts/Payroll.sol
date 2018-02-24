pragma solidity ^0.4.17;

import "../installed_contracts/zeppelin/contracts/ownership/Ownable.sol";

contract Payroll is Ownable {
  address oracleAddress;
  uint employeeCount;
  
  struct Employee {
    address account;
    address[] allowedTokens;
    uint initialSalary;
    uint currentSalary;
  }

  mapping (uint=>Employee) employees;

  mapping (address=>bool) isEmployee;

  modifier onlyEmployee() {
    require(isEmployee[msg.sender]);
    _;
  }

  modifier onlyOracle() {
    require(msg.sender == oracleAddress);
    _;
  }

  /* OWNER ONLY */
  function addEmployee(address accountAddress, address[] allowedTokens, uint256 initialYearlyUSDSalary) public onlyOwner return (uint employeeId) {
    require(employees[accountAddress].account != accountAddress);
    employeeCount += 1;
    employees[employeeCount] = Employee(accountAddress, allowedTokens, initialYearlyUSDSalary, initialYearlyUSDSalary);
    isEmployee[accountAddress] = true;
    return employeeCount;
  }  

  function setEmployeeSalary(uint256 employeeId, uint256 yearlyUSDSalary) public onlyOwner {
    employees[employeeId].currentSalary = yearlyUSDSalary;
  }

  function removeEmployee(uint256 employeeId) public onlyOwner {
    address accountAddress = employees[employeeId].account;
    require(isEmployee[accountAddress]);
    delete employees[employeeId];
    isEmployee[accountAddress] = false;

  }

  function addFunds() payable public onlyOwner {
    
  }
  function scapeHatch();
  // function addTokenFunds()? // Use approveAndCall or ERC223 tokenFallback

  function getEmployeeCount() constant returns (uint256);
  function getEmployee(uint256 employeeId) constant returns (address employee); // Return all important info too

  function calculatePayrollBurnrate() constant returns (uint256); // Monthly usd amount spent in salaries
  function calculatePayrollRunway() constant returns (uint256); // Days until the contract can run out of funds

  /* EMPLOYEE ONLY */
  function determineAllocation(address[] tokens, uint256[] distribution); // only callable once every 6 months
  function payday(); // only callable once a month

  /* ORACLE ONLY */
  function setExchangeRate(address token, uint256 usdExchangeRate); // uses decimals from token
}