# -*- coding: binary -*-
require "rex/arch/version"

module Rex


###
#
# This module provides generalized methods for performing operations that are
# architecture specific.  Furthermore, the modules contained within this
# module provide features that are specific to a given architecture.
#
###
module Arch

  #
  # Architecture classes
  #
  require 'rex/arch/x86'
  require 'rex/arch/sparc'
  require 'rex/arch/zarch'

  #
  # Architecture constants
  #
  ARCH_ANY     = '_any_'
  ARCH_X86     = 'x86'
  ARCH_X86_64  = 'x86_64'
  ARCH_X64     = 'x64' # To be used for compatability with ARCH_X86_64
  ARCH_MIPS    = 'mips'
  ARCH_MIPSLE  = 'mipsle'
  ARCH_MIPSBE  = 'mipsbe'
  ARCH_PPC     = 'ppc'
  ARCH_PPC64   = 'ppc64'
  ARCH_CBEA    = 'cbea'
  ARCH_CBEA64  = 'cbea64'
  ARCH_SPARC   = 'sparc'
  ARCH_CMD     = 'cmd'
  ARCH_PHP     = 'php'
  ARCH_TTY     = 'tty'
  ARCH_ARMLE   = 'armle'
  ARCH_ARMBE   = 'armbe'
  ARCH_JAVA    = 'java'
  ARCH_RUBY    = 'ruby'
  ARCH_DALVIK  = 'dalvik'
  ARCH_PYTHON  = 'python'
  ARCH_NODEJS  = 'nodejs'
  ARCH_FIREFOX = 'firefox'
  ARCH_ZARCH   = 'zarch'
  ARCH_TYPES   =
    [
      ARCH_X86,
      ARCH_X86_64,
      ARCH_X64,
      ARCH_MIPS,
      ARCH_MIPSLE,
      ARCH_MIPSBE,
      ARCH_PPC,
      ARCH_PPC64,
      ARCH_CBEA,
      ARCH_CBEA64,
      ARCH_SPARC,
      ARCH_ARMLE,
      ARCH_ARMBE,
      ARCH_CMD,
      ARCH_PHP,
      ARCH_TTY,
      ARCH_JAVA,
      ARCH_RUBY,
      ARCH_DALVIK,
      ARCH_PYTHON,
      ARCH_NODEJS,
      ARCH_FIREFOX,
      ARCH_ZARCH,
    ]

  ARCH_ALL = ARCH_TYPES

  #
  # Endian constants
  #
  ENDIAN_LITTLE = 0
  ENDIAN_BIG    = 1

  IS_ENDIAN_LITTLE = ( [1].pack('s') == "\x01\x00" ) ? true : false
  IS_ENDIAN_BIG    = ( not IS_ENDIAN_LITTLE )

  #
  # This routine adjusts the stack pointer for a given architecture.
  #
  def self.adjust_stack_pointer(arch, adjustment)

    if ( arch.is_a?(::Array))
      arch = arch[0]
    end

    case arch
      when /x86/
        Rex::Arch::X86.adjust_reg(Rex::Arch::X86::ESP, adjustment)
      else
        nil
    end
  end

  #
  # This route provides address packing for the specified arch
  #
  def self.pack_addr(arch, addr)

    if ( arch.is_a?(::Array))
      arch = arch[0]
    end

    case arch
      when ARCH_X86
        [addr].pack('V')
      when ARCH_X86_64, ARCH_X64
        [addr].pack('Q<')
      when ARCH_MIPS # ambiguous
        [addr].pack('N')
      when ARCH_MIPSBE
        [addr].pack('N')
      when ARCH_MIPSLE
        [addr].pack('V')
      when ARCH_PPC  # ambiguous
        [addr].pack('N')
      when ARCH_SPARC
        [addr].pack('N')
      when ARCH_ARMLE
        [addr].pack('V')
      when ARCH_ARMBE
        [addr].pack('N')
      when ARCH_ZARCH
        [addr].pack('Q>')
    end
  end

  #
  # This routine reports the endianess of a given architecture
  #
  def self.endian(arch)

    if ( arch.is_a?(::Array))
      arch = arch[0]
    end

    case arch
      when ARCH_X86
        return ENDIAN_LITTLE
      when ARCH_X86_64
        return ENDIAN_LITTLE
      when ARCH_X64
        return ENDIAN_LITTLE
      when ARCH_MIPS # ambiguous
        return ENDIAN_BIG
      when ARCH_MIPSLE
        return ENDIAN_LITTLE
      when ARCH_MIPSBE
        return ENDIAN_BIG
      when ARCH_PPC  # ambiguous
        return ENDIAN_BIG
      when ARCH_SPARC
        return ENDIAN_BIG
      when ARCH_ARMLE
        return ENDIAN_LITTLE
      when ARCH_ARMBE
        return ENDIAN_BIG
      when ARCH_ZARCH
        return ENDIAN_BIG
    end

    return ENDIAN_LITTLE
  end

end
end
