const chai = require('chai');
const {
    wasm
} = require('circom_tester');
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);
const chaiAsPromised = require("chai-as-promised");
const wasm_tester = require("circom_tester").wasm;

chai.use(chaiAsPromised);
const expect = chai.expect;


describe("IsPermutation Test ", function (){
    this.timeout(100000);

    before(async() => {
        circuit = await wasm_tester(path.join(__dirname,"../IsPermutation","IsPermutation.circom"));
        await circuit.loadConstraints();
    });

    it("Should accept permutation", async() => {
        await expect(circuit.calculateWitness({"a":[1,2,3],"b":[1,2,3]},true)).to.not.eventually.be.rejected;
        await expect(circuit.calculateWitness({"a":[1,2,3],"b":[3,2,1]},true)).to.not.eventually.be.rejected;
    });

    it("Should reject non-permutation", async() => {
        await expect(circuit.calculateWitness({"a":[1,2,3],"b":[3,1,5]},true)).to.eventually.be.rejected;
    });
})
