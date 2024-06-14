/*******************************************************************************
 * Game Genie Encoder/Decoder
 * Copyright (C) 2004-2006,2008,2016 emuWorks
 * http://games.technoplaza.net/
 *
 * This file is part of Game Genie Encoder/Decoder.
 *
 * Game Genie Encoder/Decoder is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Game Genie Encoder/Decoder is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Game Genie Encoder/Decoder; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 ******************************************************************************/
// setup system constants
const SYSTEM_NINTENDO = 0;
const SYSTEM_SUPERNINTENDO = 1;
const SYSTEM_GENESIS = 2;
const SYSTEM_GBGG = 3;

// the Game Boy / Game Gear game genie alphabet
const ALPHABET_GBGG = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
];

// the Genesis game genie alphabet
const ALPHABET_GENESIS = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'R',
    'S',
    'T',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
];

// the NES game genie alphabet
const ALPHABET_NES = [
    'A',
    'P',
    'Z',
    'L',
    'G',
    'I',
    'T',
    'Y',
    'E',
    'O',
    'X',
    'U',
    'K',
    'S',
    'V',
    'N',
];

// the SNES game genie alphabet
const ALPHABET_SNES = [
    'D',
    'F',
    '4',
    '7',
    '0',
    '9',
    '1',
    '5',
    '6',
    'B',
    'C',
    '8',
    'A',
    '2',
    '3',
    'E',
];

// the system we are working with
var system = SYSTEM_NINTENDO;

// program version
var version = '0.80';

// object representing a raw code
function RawCode() {
    this.value = 0;
    this.address = 0;
    this.compare = 0;
}

RawCode.prototype.hasCompare = function () {
    return this.compare != 0;
};

// decodes a game boy or game gear game genie code into a raw code
function decodeGBGG(code) {
    var rawCode = new RawCode();

    if (isValidGBGGCode(code)) {
        code = code.toUpperCase();
        var hex = [];

        for (var i = 0; i < code.length; i++) {
            if (i == 3 || i == 7) {
                continue;
            }

            hex.push(ALPHABET_GBGG.indexOf(code.charAt(i)));
        }
    }

    rawCode.value = (hex[0] << 4) | hex[1];
    rawCode.address =
        (hex[2] << 8) | (hex[3] << 4) | hex[4] | ((~hex[5] & 0xf) << 12);

    var x = (hex[2] << 8) | (hex[3] << 4) | hex[4];
    var y = (~hex[5] & 0xf) << 12;

    if (code.length == 11) {
        var temp = (hex[6] << 4) | hex[8];
        temp = (temp >> 2) | ((temp << 6) & 0xfc);
        rawCode.compare = temp ^ 0xba;
    }

    return rawCode;
}

// decodes a genesis game genie code into a raw code
function decodeGenesis(code) {
    var rawCode = new RawCode();

    if (isValidGenesisCode(code)) {
        code = code.toUpperCase();
        var hex = [];

        for (var i = 0; i < code.length; i++) {
            if (i == 4) {
                continue;
            }

            hex.push(ALPHABET_GENESIS.indexOf(code.charAt(i)));
        }

        rawCode.value =
            ((hex[5] & 0x01) << 15) |
            (((hex[6] & 0x18) >> 3) << 13) |
            ((hex[4] & 0x01) << 12) |
            (((hex[5] & 0x1e) >> 1) << 8) |
            (hex[0] << 3) |
            ((hex[1] & 0x1c) >> 2);

        rawCode.address =
            hex[7] |
            ((hex[6] & 0x03) << 5) |
            (((hex[3] & 0x10) >> 4) << 8) |
            (hex[2] << 9) |
            ((hex[1] & 0x03) << 14) |
            (((hex[4] & 0x1e) >> 1) << 16) |
            ((hex[3] & 0x0f) << 20);
    }

    return rawCode;
}

// decodes a nintendo game genie code into a raw code
function decodeNES(code) {
    var rawCode = new RawCode();

    if (isValidNESCode(code)) {
        code = code.toUpperCase();
        var bitString = 0;

        for (var i = 0; i < code.length; i++) {
            var letter = code.charAt(i);
            bitString <<= 4;
            bitString |= ALPHABET_NES.indexOf(letter);
        }

        var temp;

        if (code.length == 6) {
            bitString <<= 8;
        }

        rawCode.value = ((bitString >> 28) & 0x8) | ((bitString >> 24) & 0x7);

        if (code.length == 6) {
            temp = (bitString & 0x800) >> 8;
        } else {
            temp = bitString & 0x8;
        }

        temp |= (bitString >> 28) & 0x7;

        rawCode.value <<= 4;
        rawCode.value |= temp;

        rawCode.address = (bitString & 0x70000) >> 16;

        temp = ((bitString & 0x8000) >> 12) | ((bitString & 0x700) >> 8);
        rawCode.address <<= 4;
        rawCode.address |= temp;

        temp = ((bitString & 0x8000000) >> 24) | ((bitString & 0x700000) >> 20);
        rawCode.address <<= 4;
        rawCode.address |= temp;

        temp = ((bitString & 0x80000) >> 16) | ((bitString & 0x7000) >> 12);
        rawCode.address <<= 4;
        rawCode.address |= temp;

        if (code.length == 8) {
            rawCode.compare = ((bitString & 0x80) >> 4) | (bitString & 0x7);

            temp = ((bitString & 0x800) >> 8) | ((bitString & 0x70) >> 4);
            rawCode.compare <<= 4;
            rawCode.compare |= temp;
        }
    }

    return rawCode;
}

// decodes a super nintendo game genie code into a raw code
function decodeSNES(code) {
    var rawCode = new RawCode();

    if (isValidSNESCode(code)) {
        code = code.toUpperCase();
        var bitString = 0;

        for (var i = 0; i < code.length; i++) {
            if (i == 4) {
                continue;
            }

            var letter = code.charAt(i);
            bitString <<= 4;
            bitString |= ALPHABET_SNES.indexOf(letter);
        }

        var temp;

        rawCode.value = (bitString >> 24) & 0xff;

        rawCode.address = ((bitString >> 10) & 0xc) | ((bitString >> 10) & 0x3);

        temp = ((bitString >> 2) & 0xc) | ((bitString >> 2) & 0x3);
        rawCode.address <<= 4;
        rawCode.address |= temp;

        temp = (bitString >> 20) & 0xf;
        rawCode.address <<= 4;
        rawCode.address |= temp;

        temp = ((bitString << 2) & 0xc) | ((bitString >> 14) & 0x3);
        rawCode.address <<= 4;
        rawCode.address |= temp;

        temp = (bitString >> 16) & 0xf;
        rawCode.address <<= 4;
        rawCode.address |= temp;

        temp = ((bitString >> 6) & 0xc) | ((bitString >> 6) & 0x3);
        rawCode.address <<= 4;
        rawCode.address |= temp;
    }

    return rawCode;
}

// encodes a raw code into a game boy/game gear game genie code
function encodeGBGG(rawCode) {
    var code = '';
    var temp,
        genie = 0;

    if (isValidRawCode(rawCode)) {
        var address = parseInt(rawCode.address, 16);

        temp = (address & 0xf000) >> 12;
        temp = ~temp & 0xf;
        temp |= (address & 0xfff) << 4;
        genie <<= 16;
        genie |= temp;

        if (rawCode.hasCompare()) {
            var compare = parseInt(rawCode.compare, 16);

            compare ^= 0xba;
            compare = (compare << 2) | (compare >> 6);
            temp = (compare & 0xf0) >> 4;
            genie <<= 4;
            genie |= temp;

            temp ^= 8;
            genie <<= 4;
            genie |= temp;

            temp = compare & 0xf;
            genie <<= 4;
            genie |= temp;
        }

        for (var i = 0; i < (rawCode.hasCompare() ? 7 : 4); i++) {
            if (i == 3 || i == 6) {
                code = '-' + code;
            }

            code = ALPHABET_GBGG[(genie >> (i * 4)) & 0xf] + code;
        }

        code = rawCode.value + code;
    }

    return code;
}

// encodes a raw code into a sega genesis game genie code
function encodeGenesis(rawCode) {
    var code = '';
    var temp;
    var genie = [0, 0];

    if (isValidRawCode(rawCode)) {
        var value = parseInt(rawCode.value, 16);
        var address = parseInt(rawCode.address, 16);

        genie[1] = (value & 0xf0) >> 4;

        temp = value & 0xf;
        genie[1] <<= 4;
        genie[1] |= temp;

        temp = (address & 0xf000) >> 12;
        genie[1] <<= 4;
        genie[1] |= temp;

        temp = (address & 0xf00) >> 8;
        genie[1] <<= 4;
        genie[1] |= temp;

        temp = (address & 0xf00000) >> 20;
        genie[1] <<= 4;
        genie[1] |= temp;

        genie[0] = (address & 0xf0000) >> 16;

        temp = ((value & 0x1000) >> 9) | ((value & 0xe00) >> 9);
        genie[0] <<= 4;
        genie[0] |= temp;

        temp = ((value & 0x100) >> 5) | ((value & 0xe000) >> 13);
        genie[0] <<= 4;
        genie[0] |= temp;

        temp = (address & 0xf0) >> 4;
        genie[0] <<= 4;
        genie[0] |= temp;

        temp = address & 0xf;
        genie[0] <<= 4;
        genie[0] |= temp;
    }

    for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 4; j++) {
            code = ALPHABET_GENESIS[(genie[i] >> (j * 5)) & 0x1f] + code;
        }

        if (i == 0) {
            code = '-' + code;
        }
    }

    return code;
}

// encodes a raw code into a nintendo game genie code
function encodeNES(rawCode) {
    var code = '';
    var genie, temp;

    if (isValidRawCode(rawCode)) {
        var value = parseInt(rawCode.value, 16);
        var address = parseInt(rawCode.address, 16);

        genie = ((value & 0x80) >> 4) | (value & 0x7);

        temp = ((address & 0x80) >> 4) | ((value & 0x70) >> 4);
        genie <<= 4;
        genie |= temp;

        temp = (address & 0x70) >> 4;

        if (rawCode.hasCompare()) {
            temp |= 0x8;
        }

        genie <<= 4;
        genie |= temp;

        temp = (address & 0x8) | ((address & 0x7000) >> 12);
        genie <<= 4;
        genie |= temp;

        temp = ((address & 0x800) >> 8) | (address & 0x7);
        genie <<= 4;
        genie |= temp;

        if (rawCode.hasCompare()) {
            var compare = parseInt(rawCode.compare, 16);

            temp = (compare & 0x8) | ((address & 0x700) >> 8);
            genie <<= 4;
            genie |= temp;

            temp = ((compare & 0x80) >> 4) | (compare & 0x7);
            genie <<= 4;
            genie |= temp;

            temp = (value & 0x8) | ((compare & 0x70) >> 4);
            genie <<= 4;
            genie |= temp;
        } else {
            temp = (value & 0x8) | ((address & 0x700) >> 8);
            genie <<= 4;
            genie |= temp;
        }

        for (var i = 0; i < (rawCode.hasCompare() ? 8 : 6); i++) {
            code = ALPHABET_NES[(genie >> (i * 4)) & 0xf] + code;
        }
    }

    return code;
}

// encodes a raw code into a super nintendo code
function encodeSNES(rawCode) {
    var code = '';
    var genie, temp;

    if (isValidRawCode(rawCode)) {
        var value = parseInt(rawCode.value, 16);
        var address = parseInt(rawCode.address, 16);

        genie = value;

        temp = (address & 0xf000) >> 12;
        genie <<= 4;
        genie |= temp;

        temp = (address & 0xf0) >> 4;
        genie <<= 4;
        genie |= temp;

        temp = ((address & 0x300) >> 6) | (address >> 22);
        genie <<= 4;
        genie |= temp;

        temp = ((address & 0x300000) >> 18) | ((address & 0xc) >> 2);
        genie <<= 4;
        genie |= temp;

        temp = ((address & 0x3) << 2) | ((address & 0xc0000) >> 18);
        genie <<= 4;
        genie |= temp;

        temp = ((address & 0x30000) >> 14) | ((address & 0xc00) >> 10);
        genie <<= 4;
        genie |= temp;

        for (var i = 0; i < 8; i++) {
            if (i == 4) {
                code = '-' + code;
            }

            code = ALPHABET_SNES[(genie >> (i * 4)) & 0xf] + code;
        }
    }

    return code;
}

// formats a raw code for display
function formatRawCode(code) {
    var formatted = {
        value: code.value.toString(16),
        address: code.address.toString(16),
        compare: code.compare.toString(16),
    };

    if (code.value != 0) {
        var length = system == SYSTEM_GENESIS ? 4 : 2;

        while (formatted.value.length < length) {
            formatted.value = '0' + formatted.value;
        }

        formatted.value = formatted.value.toUpperCase();
    }

    if (code.address != 0) {
        var length =
            system == SYSTEM_SUPERNINTENDO || system == SYSTEM_GENESIS ? 6 : 4;

        while (formatted.address.length < length) {
            formatted.address = '0' + formatted.address;
        }

        formatted.address = formatted.address.toUpperCase();
    }

    if (system == SYSTEM_NINTENDO || system == SYSTEM_GBGG) {
        if (code.compare != 0) {
            while (formatted.compare.length < 2) {
                formatted.compare = '0' + formatted.compare;
            }

            formatted.compare = formatted.compare.toUpperCase();
        }
    } else {
        formatted.compare = '';
    }

    return formatted;
}

// checks if the string is a valid game boy / game gear game genie code
function isValidGBGGCode(code) {
    // make string upper case for easier comparison
    code = code.toUpperCase();

    // GBGG codes are either 7 or 11 characters
    if (code.length != 7 && code.length != 11) {
        return false;
    }

    if (code.charAt(3) != '-' || (code.length == 11 && code.charAt(7) != '-')) {
        return false;
    }

    for (var i = 0; i < code.length; i++) {
        if (i == 3 || i == 7) {
            continue;
        }

        if (ALPHABET_GBGG.indexOf(code.charAt(i)) == -1) {
            return false;
        }
    }

    return true;
}

// checks if the supplied code is a valid genesis code
function isValidGenesisCode(code) {
    // make string upper case for easier comparison
    code = code.toUpperCase();

    // SNES codes are 9 characters
    if (code.length != 9) {
        return false;
    }

    // the middle character must be a dash
    if (code.charAt(4) != '-') {
        return false;
    }

    for (var i = 0; i < code.length; i++) {
        if (i == 4) {
            continue;
        }

        if (ALPHABET_GENESIS.indexOf(code.charAt(i)) == -1) {
            return false;
        }
    }

    return true;
}

// checks if the supplied code is a nintendo code
function isValidNESCode(code) {
    // make string upper case for easier comparison
    code = code.toUpperCase();

    // NES codes are either 6 or 8 characters
    if (code.length != 6 && code.length != 8) {
        return false;
    }

    // NES codes can only contain 'letters' in the NES game genie alphabet
    for (var i = 0; i < code.length; i++) {
        if (ALPHABET_NES.indexOf(code.charAt(i)) == -1) {
            return false;
        }
    }

    // if we didn't bail out, we must be a valid code
    return true;
}

// checks whether the supplied code is a valid raw code for this system
function isValidRawCode(code) {
    var temp = parseInt(code.value, 16);

    if (isNaN(temp)) {
        return false;
    }

    if (system == SYSTEM_GENESIS) {
        if (temp < 0 || temp > 65535) {
            return false;
        }
    } else {
        if (temp < 0 || temp > 255) {
            return false;
        }
    }

    temp = parseInt(code.address, 16);

    if (isNaN(temp)) {
        return false;
    }

    if (system == SYSTEM_SUPERNINTENDO || system == SYSTEM_GENESIS) {
        if (temp < 0 || temp > 16777215) {
            return false;
        }
    } else {
        if (temp < 0 || temp > 65535) {
            return false;
        }
    }

    if (
        code.hasCompare() &&
        (system == SYSTEM_NINTENDO || system == SYSTEM_GBGG)
    ) {
        temp = parseInt(code.compare, 16);

        if (isNaN(temp)) {
            return false;
        }

        if (temp < 0 || temp > 255) {
            return false;
        }
    }

    return true;
}

// checks if the supplied code is a valid super nintendo code
function isValidSNESCode(code) {
    // make string upper case for easier comparison
    code = code.toUpperCase();

    // SNES codes are 9 characters
    if (code.length != 9) {
        return false;
    }

    // the middle character must be a dash
    if (code.charAt(4) != '-') {
        return false;
    }

    for (var i = 0; i < code.length; i++) {
        if (i == 4) {
            continue;
        }

        if (ALPHABET_SNES.indexOf(code.charAt(i)) == -1) {
            return false;
        }
    }

    return true;
}

module.exports = { encodeNES, decodeNES };
