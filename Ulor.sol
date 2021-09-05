// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Erc20.sol";

interface Tkn{
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);
    
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Ulor is ERC20{

    
    address internal owner;
    
    
    
    mapping(address => bool) private GovAdrMap;
    
    modifier onlyOwner (){
        require(msg.sender == owner,"Only owner have access to this");
        _;
    }
    
    modifier onlyGov (){
        require(GovAdrMap[msg.sender]  == true,"Only Goverance have access to this");
        _;
    }
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    event AddedGovRec(address indexed GovAddr, address indexed PermitBy);
    
    event DelGovRec(address indexed GovAddr, address indexed deletedBy);
    
    event addressPauseEvt(address indexed pAddress, address indexed pausedBy);
    
    event addressUnPauseEvt(address indexed upAddress, address indexed unPausedBy);
    
    event TknWithDraw(address indexed Spender, uint Amount, address contractAdr);
    
    event BurnTknEvt(address indexed Burner, uint Amount);
    
    constructor() public  ERC20("ULOR","ULO"){
        _mint(msg.sender,(500000000000) * (10 ** uint256(decimals() )));
        
        _setOwner(msg.sender);
    }
    
    function pauseAddress(address adr) public onlyGov{
        setPause(true,adr);
        emit addressPauseEvt(adr, msg.sender);
    }
    
    function unPauseAddress(address adr) public onlyGov{
        setPause(false,adr);
        emit addressUnPauseEvt(adr, msg.sender);
    }
    
    function InqPauseAddre(address adr) public view returns(bool Paused){
        return(PauseAddr[adr]);
    }
    
    function transferOwnership(address newOwner) public  onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
    
    function addGov(address newGov) public onlyOwner{
        GovAdrMap[newGov] = true;
        emit AddedGovRec(newGov, msg.sender);
    }
    
    function removeGov(address remGov) public onlyOwner{
        GovAdrMap[remGov] = false;
        emit DelGovRec(remGov,msg.sender);
    }
    
    function BurnTkn(uint amt) public onlyGov{
        
        uint256 brntk = (amt) * (10 ** uint256(18 ));
        
        _burn(msg.sender,brntk);
        
        emit BurnTknEvt(msg.sender,amt);
    }
    
    function withdrawBNB() public onlyOwner returns(uint){
        uint conBal = address(this).balance;
        payable(msg.sender).transfer(conBal);
        
        emit TknWithDraw(msg.sender,conBal, address(this));
        
        return conBal;
    }
    
    function withdrawERC(uint amt, address contractAdr) public onlyGov {
        Tkn Token = Tkn(contractAdr);
        
        uint256 sndtk = (amt) * (10 ** uint256(18 ));
        
        Token.transfer(msg.sender,sndtk);
        
        emit TknWithDraw(msg.sender,sndtk, contractAdr);
        
    }
    
    receive() external payable{
        
    }
    
    fallback() external payable{
        
    }
}
