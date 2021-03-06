
.SUFFIXES:

ROMName := example
ROMExt  := gb
Version := 0

# I'm keeping the name here for posterity, but you'd probably want to change it
GameTitle := hUGEDriver
GameID    := HUGE
Licensee  := HB
MBCType   := 0
SRAMSize  := 0

SRCDIR := src
OBJDIR := obj
DEPDIR := dep
BINDIR := bin


RGBASM  := rgbasm
RGBLINK := rgblink
RGBFIX  := rgbfix

INCDIRS := $(SRCDIR)/ $(SRCDIR)/include/ $(SRCDIR)/fortISSimO/
PADValue := 0xFF

ASFLAGS := -p $(PADValue) -E -h $(addprefix -i ,$(INCDIRS))
LDFLAGS := -p $(PADValue) -d
FXFLAGS := -p $(PADValue) -v -i $(GameID) -k $(Licensee) -l 0x33 -m $(MBCType) -n $(Version) -r $(SRAMSize) -t $(GameTitle)


VPATH := $(INCDIRS)

SRCLIST := $(wildcard $(SRCDIR)/*.asm)
OBJLIST := $(patsubst $(SRCDIR)/%.asm,$(OBJDIR)/%.o,$(SRCLIST))
DEPLIST := $(patsubst $(SRCDIR)/%.asm,$(DEPDIR)/%.d,$(SRCLIST))


all: $(BINDIR)/$(ROMName).$(ROMExt)
.PHONY: all

clean:
	rm -rf $(OBJDIR) $(DEPDIR) $(BINDIR)
.PHONY: clean

$(BINDIR)/$(ROMName).$(ROMExt): $(OBJLIST)
	@mkdir -p $(@D)
	$(RGBLINK) $(LDFLAGS) -m $(@:.$(ROMExt)=.map) -n $(@:.$(ROMExt)=.sym) -o $@ $^
	$(RGBFIX) $(FXFLAGS) $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@mkdir -p $(@D)
	$(RGBASM) $(ASFLAGS) -o $@ $<

$(DEPDIR)/%.d: $(SRCDIR)/%.asm
	@mkdir -p $(@D)
	$(RGBASM) $(ASFLAGS) -M $@ -MP -MQ $(OBJDIR)/$*.o -MQ $@ $<

ifneq ($(MAKECMDGOALS),clean)
include $(DEPLIST)
endif
