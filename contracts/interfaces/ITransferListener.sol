pragma solidity ^0.5.6;

contract ITransferListener {
    function transfer(
        address from,
        address to,
        uint256 tokenId
    ) external;
}
