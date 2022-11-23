// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Roulette.sol";

contract wtfsolidity_safe is Test {
    Roulette roulette;
    address alice;

    function setUp() public {
        roulette = new Roulette();
        alice = vm.addr(1);
        alice.call{value: 1 ether}("");
        address(roulette).call{value: 10 ether}("");
    }

    // forge test -vv --match-test  testRoulette
    function testRoulette() public {
        vm.warp(7);
        vm.startPrank(alice);
        console.log("alice balance before: %s", alice.balance / 1 ether);
        console.log("roulette balance before: %s ", address(roulette).balance / 1 ether);
        roulette.spin{value: 1 ether}();
        console.log("alice balance after: %s", alice.balance / 1 ether);
        console.log("roulette balance after: %s ", address(roulette).balance / 1 ether);
        vm.stopPrank();
    }

    receive() external payable {}
}
