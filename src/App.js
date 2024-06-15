import SyntaxHighlighter from 'react-syntax-highlighter';
import { useState } from 'react';
import { dracula } from 'react-syntax-highlighter/dist/esm/styles/hljs/';
import opcodeLookup from './opcodes.js';
import addressModes from './modes.js';
import './App.css';
const { RawCode, encodeNES, decodeNES, isValidNESCode } = require('./gg.js');

const nullOpcodes = {
    ogOpcode: null,
    ogAddressing: null,
    modOpcode: null,
    modAddressing: null,
};
function getNewDisplay() {
    return {
        code: '',
        address: '',
        original: '',
        modified: '',
    };
}

function OpCodeDisplay({ opcode, addressMode, hide }) {
    if (hide) return 'N/A';
    return addressMode ? (
        <>
            <a
                href={
                    'http://www.6502.org/tutorials/6502opcodes.html#' + opcode
                }
            >
                {opcode}
            </a>{' '}
            {addressMode}
        </>
    ) : (
        <>
            <a
                href={
                    'https://www.masswerk.at/6502/6502_instruction_set.html#' +
                    opcode
                }
            >
                {opcode}
            </a>{' '}
            {' illegal!'}
        </>
    );
}

function getGGCode(address, value) {
    var rawCode = new RawCode();
    rawCode.value = value;
    rawCode.address = address;
    return encodeNES(rawCode);
}
function App() {
    const [disasm, setDisasm] = useState('');
    const [loaded, setLoaded] = useState(false);
    const [lookupTable, setLookupTable] = useState([]);
    const [windowObj, setWindowObj] = useState('');
    const [lineNo, setLineNo] = useState(0);
    const [startNo, setStartNo] = useState(1);
    const [opcodes, setOpcodes] = useState(nullOpcodes);
    const [display, setDisplay] = useState({
        code: '',
        address: '',
        original: '',
        modified: '',
    });

    function updateOpcodes(address, ogByte, modByte) {
        if (!isNaN(address) && lookupTable[address][3]) {
            setOpcodes({
                ogOpcode: opcodeLookup[ogByte],
                ogAddressing: addressModes[ogByte],
                modOpcode: opcodeLookup[modByte],
                modAddressing: addressModes[modByte],
            });
        } else {
            setOpcodes(nullOpcodes);
        }
    }
    function setWindow(lineNo) {
        if (lineNo === null) return;
        const newWindow = [];
        const disasmLines = disasm.split(/\n/);
        const start = Math.max(lineNo - 20, 0);
        const end = Math.min(lineNo + 20, disasmLines.length);
        newWindow.push(...disasmLines.slice(start, lineNo));
        newWindow.push(...disasmLines.slice(lineNo, end));
        setStartNo(start + 1);
        setWindowObj(newWindow.join('\n'));
    }
    function getLookupTable() {
        fetch('disasm.s').then((response) =>
            response.text().then((text) => {
                // [[lineno, index], ...]
                let lookup = [];
                setDisasm(text);
                let data = text.split(/\n/);
                for (let lineNo = 0; lineNo < data.length; lineNo += 1) {
                    // find address & bytes
                    let search = data[lineNo].match(
                        /; [89A-F][A-F0-9]{3} (.*)/,
                    );
                    if (search !== null) {
                        let isOpCode = false;
                        if (data[lineNo].match(/^\s+[a-z]{3}/)) {
                            isOpCode = true;
                        }
                        const bytes = search[1]
                            .split(' ')
                            .map((b) => parseInt(b, 16));
                        lookup.push(
                            ...[...Array(bytes.length).keys()].map((bidx) => [
                                lineNo,
                                bidx,
                                bytes[bidx],
                                bidx === 0 ? isOpCode : false,
                            ]),
                        );
                    }
                }
                setLookupTable(lookup);
            }),
        );
    }

    function handleAddress(event) {
        const newAddressDisplay = event.target.value;
        const newDisplay = getNewDisplay();
        const newAddress = parseInt(newAddressDisplay, 16) - 0x8000;
        newDisplay.address = newAddressDisplay;
        newDisplay.modified = display.modified;
        updateOpcodes(undefined);
        if (isNaN(newAddress) || newAddress < 0 || newAddress >= 0x8000) {
            setDisplay(newDisplay);
            setLineNo(null);
            return;
        }
        const ogByte = lookupTable[newAddress][2];
        newDisplay.original = ogByte.toString(16);
        setLineNo(lookupTable[newAddress][0]);
        if (display.modified !== '') {
            updateOpcodes(newAddress, ogByte, parseInt(display.modified, 16));
            const newCode = getGGCode(newAddressDisplay, display.modified);
            newDisplay.code = newCode;
        }
        setDisplay(newDisplay);
    }
    function handleModified(event) {
        const newModifiedDisplay = event.target.value;
        const ogByte = parseInt(display.original, 16);
        const address = parseInt(display.address, 16) - 0x8000;
        const newDisplay = getNewDisplay();
        newDisplay.address = display.address;
        newDisplay.original = display.original;
        newDisplay.modified = newModifiedDisplay;
        const newByte = parseInt(newModifiedDisplay, 16);
        updateOpcodes(undefined);
        if (isNaN(newByte) || newByte < 0 || newByte >= 0x100) {
            setDisplay(newDisplay);
            return;
        }
        if (display.address !== '') {
            const newCode = getGGCode(display.address, newModifiedDisplay);
            newDisplay.code = newCode;
        }
        updateOpcodes(address, ogByte, newByte);
        setDisplay(newDisplay);
    }

    function handleGGCode(event) {
        const code = event.target.value;
        const newDisplay = getNewDisplay();
        newDisplay.code = code;
        const valid = isValidNESCode(code);
        if (!valid) {
            setLineNo(null);
            setDisplay(newDisplay);
            return;
        }
        const decoded = decodeNES(code);
        setLineNo(lookupTable[decoded.address][0]);
        const ogByte = lookupTable[decoded.address][2];
        newDisplay.address = (decoded.address + 0x8000).toString(16);
        newDisplay.modified = decoded.value.toString(16);
        newDisplay.original = ogByte.toString(16);
        setDisplay(newDisplay);
        updateOpcodes(decoded.address, ogByte, decoded.value);
    }

    if (!loaded) {
        getLookupTable();
        setLoaded(true);
    }
    return (
        <div className="App">
            <header className="App-header">
                <fieldset>
                    <legend>Inputs</legend>
                    <p>
                        <label htmlFor="gg">GG Code:</label>
                        <input
                            id="gg"
                            value={display.code}
                            onChange={(e) => handleGGCode(e)}
                            onKeyDown={(e) =>
                                e.key === 'Enter' && setWindow(lineNo)
                            }
                        ></input>
                    </p>
                    <p>
                        <label htmlFor="address">Address:</label>
                        <input
                            id="address"
                            onChange={(e) => handleAddress(e)}
                            value={display.address}
                            onKeyDown={(e) =>
                                e.key === 'Enter' && setWindow(lineNo)
                            }
                        ></input>
                    </p>
                    <p>
                        <label htmlFor="original">Original:</label>
                        <input
                            id="original"
                            disabled="true"
                            value={display.original}
                        ></input>{' '}
                    </p>
                    <p>
                        <label htmlFor="modified">Modified:</label>
                        <input
                            id="modified"
                            onChange={(e) => handleModified(e)}
                            value={display.modified}
                            onKeyDown={(e) =>
                                e.key === 'Enter' && setWindow(lineNo)
                            }
                        ></input>{' '}
                    </p>
                </fieldset>
                <p>
                    Original Opcode:{' '}
                    <OpCodeDisplay
                        opcode={opcodes.ogOpcode}
                        addressMode={opcodes.ogAddressing}
                        hide={!opcodes.ogOpcode}
                    />
                </p>
                <p>
                    Modified Opcode:{' '}
                    <OpCodeDisplay
                        opcode={opcodes.modOpcode}
                        addressMode={opcodes.modAddressing}
                        hide={!opcodes.ogOpcode} // don't show unless original was an opcode
                    />
                </p>
                <p>
                    <button onClick={() => setWindow(lineNo)}>show code</button>
                </p>
                {windowObj && (
                    <SyntaxHighlighter
                        children={windowObj}
                        language="x86asm"
                        showLineNumbers={true}
                        startingLineNumber={startNo}
                        style={dracula}
                        wrapLines={true}
                        lineProps={(lineNumber) => {
                            const style = {
                                display: 'block',
                                width: 'fit-content',
                            };
                            if (lineNumber === lineNo + 1) {
                                style.backgroundColor = '#284a56'; //#282a36
                            }
                            return { style };
                        }}
                    />
                )}
            </header>
        </div>
    );
}

export default App;
