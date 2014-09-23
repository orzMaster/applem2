Delphi port of Haaf's Game Engine 1.7
By Erik van Bilsen

Original C++ version:
Copyright (C) 2003-2007, Relish Games
http://hge.relishgames.com

This port uses as much as the original class names, function names and data
types as the original C++ version as possible. So it should be easy to follow
along the documentation and tutorials that come with the original version.

Delphi 2006 or later only
=========================

This Delphi port only compiles on Delphi 2006 or later. One of the reasons not
to support older Delphi versions, is that the HGE C++ code uses operator
overloading and methods within records, which are not supported in earlier
Delphi verions.

Requirements & Third Party libraries
====================================

Like the original version, this port requires DirectX 8 or later. Unlike the
original version, you also need to deploy the D3DX81ab DLL with your
application. This DLL is found in the 'Deploy' directory.
This port uses the DirectX header translations from Tim Baumgarten. You can
find these in the 'Source\DirectX' directory.

Also like the original version, this port uses Bass for sound and music, and
you need to deploy the Bass.dll file with your application (also found in the
'Deploy' directory). The 'Source\Bass' directory contains the original Delphi
interface to this DLL, which I have modified to support dynamic loading of the
DLL.

The original version uses ZLib in combination with MiniZip to pack resources
into ZIP files. This port uses a Delphi version of the ZLib and MiniZip
libraries, which can be found in the 'Source\ZLib' directory. The Delphi
translation is done by Jacques Nomssi Nzali. However, this version does not
support password protected ZIP files, so you cannot pass a password to the
Resource_AttachPack method of the HGE object.

Setup
=====

The only setup you need is to add the HGE source folders to a search path.

If you want HGE to be available to all projects, you can add these directories
to the library path (Tools > Options > Environment Options > Delphi Options >
Library - Win32 > Lirary path). You need to supply absolute directory paths in
this case.

You can also specify the HGE folders for each project separately by setting the
project search path (Project > Options > Directories/Conditionals >
Search path). You can supply both absolute and relative directory paths here.
All tutorials use this approach.

You must add the following directories to a search path:
  <Installation folder>\HGE\Source
  <Installation folder>\HGE\Source\Bass
  <Installation folder>\HGE\Source\DirectX
  <Installation folder>\HGE\Source\ZLib

Differences with the C++ version
================================

HGE.dll
-------
You DON'T need to deploy the HGE.dll file with your application. The core HGE
functionality is always linked directly into your application.

Object interfaces
-----------------
The Delphi version of HGE is completely interface based. In the original
version, only the main HGE class uses a sort of interface (it is a completely
virtual and abstract class).
This simplifies design and maintainance of your projects, and also has the
additional advantage of automated memory management.

The main HGE class is represented in Delphi with an IHGE interface. You still
use to global HGECreate function to create an instance of an IHGE object, but
you don't use the Release method to release the object. Interfaced objects
are automatically freed when they go out of scope.

Likewise, the helper classes (like hgeSprite, hgeFont etc.) are also represented
with interfaces (called IHGESprite, IHGEFont etc.). These interfaces are
implemented in classes named THGESprite, THGEFont etc. To create a helper class,
you must always create a variable of the corresponding interface type (NOT of
the class type) and call the constructor on the class type, for example:

var
  S: IHGESprite; // NOT THGESprite!
begin
  S := THGESprite.Create(...);
end;

This way you enjoy the benefits of automatic memory management.

Resource handles
----------------
The original version uses generic handles (DWORDS) to represent common resources
like textures, sound effects or audio streams. You create or load these
resources by using helper methods of the HGE class, for example Effect_Load,
which returns a handle of type HEFFECT. You can then play the sound effect by
calling Effect_Play, passing this handle. And when you are done with the effect,
you call Effect_Free, again passing the handle.

In the Delphi version, all resources are represented with interfaces again, to
make resource management as simple as (helper) object management. This way, you
can treat resources the same way as you treat (helper) objects. In the sound
effect example, the Effect_Load method still loads a sound effect, but now
returns a IEffect interface. You can still call Effect_Play if you want, passing
this interface, or you can call the IEffect.Play method instead (which usually
is easier and more 'natural'). Since resources are interfaces now, you don't
need to explicitly free them, so there is no Effect_Free method anymore. Of
course, you can always free a resource explicitly by setting it to nil. This
frees the resource if there are no other references to it. For example:

var
  Effect: IEffect;
begin
  Effect := HGE.Effect_Load('Data.wav');
  Effect.Play;
  Effect := nil; // Free resource explicitly
end;

Of course, in the example above, the resource would have been freed anyway as
soon as the Effect variable went out of scope. But in some situations you might
want to release a resource before it goes out of scope.

The same goes for other types of resources. For example, there is an ITexture
interface that replaces the HTEXTURE handle. And you can call ITexture.Lock
instead of the Texture_Lock method from the HGE object.

Unsupported classes
-------------------
Currently, the following classes are unsupported:
-hgeStringTable
-hgeResourceManager

Extensions to the HGE framework
===============================
The Delphi port includes a couple of extensions that aren't available in the
original HGE engine.

Physics
-------
The Delphi port includes a simple box-based physics engine based on Box2D
(see http://www.gphysics.com). The source code for this engine can be found in
the HGEPhysics unit. You will mostly use the following interfaces:
-IHGEBody
-IHGEJoint
-IHGEWorld

The physics engine uses the new THGEMatrix record for its calculations. The
source code for this record and its methods can be found in HGEMatrix.

The APITester application shows some examples of using the physics engine.
(These examples are also taken from Box2D).

JPEG2000
--------
The Texture_Load function can also be used to load JPEG2000 files, however
with the following limitations:
-Only .JP2 and .J2K files are supported
-Only RGB images with 8 bits per channel are supported
-Subsampled images and images with signed channels are not supported

Fortunately, most JPEG2000 files comply with these limitations and all imaging
applications that support JPEG2000 can save files in the correct format.

Separate image and alpha channels (masks)
-----------------------------------------
If you want to load images with transparency (or alpha channel), you need to
use an image format that supports this, like PNG. However, PNG images don't
compress very well because it uses lossless compression.
JPEG and JPEG2000 on the other hand, compress images much better (because these
use lossy compression), but don't support alpha channels. (Actually, JPEG2000
supports alpha channels, but that is not used very much and unsupported by
the engine).

A solution to this problem is to separate an image into two different files:
1. a file that contains the image data. This file is usually saved as a JPEG or
   JPEG2000 file.
2. a file that contains only the alpha channel or mask. This file is usually
   saved in a lossless format such as PNG or TGA. In most cases, PNG is
   preferred for its better compression.

The Texture_Load function of the HGE framework is extended to support this
scenario. If you pass 2 filenames to this method (or 2 data buffers), it will
load the image data from the first file and the transparency information from
the second file, and merge these into a single texture.

If the second file contains an explicit alpha channel, then this alpha channel
is applied to the image.
If the second file doesn't contain an alpha channel, it is assumed to be a
grayscale image, and the gray levels are used for masking (where black is
considered transparent and white is considered opaque).

Deriving subclasses
===================

Sometimes you may want to derive your own subclass from a HGE class. An
example of this can be found in Tutorial06, where a new THGEGUIMenuItem is
derived from the base class THGEGUIObject. In the interface based model
described above, you must do the following to create your subclass:

1. Create a new interface type, derived from the base interface. For example:

type
  IHGEGUIMenuItem = interface(IHGEGUIObject)
  ['{5CCA857A-6DFF-4B0D-B58E-601823570B5B}']
    ...
  end;

(Note: The GUID below the interface name must be unique. To create a new GUID,
press Ctrl+Shift+G in Delphi).

2. Add all the properties and methods you want to expose to the interface
declaration. For example:

type
  IHGEGUIMenuItem = interface(IHGEGUIObject)
  ['{5CCA857A-6DFF-4B0D-B58E-601823570B5B}']
    procedure Render;
    procedure Enter;
    procedure Leave;
  end;

3. Create a new class type, derived from the base class type, and implement the
new interface. You should make the methods in the interface private or
protected, to avoid users calling these methods on the class directly.
For example:

type
  THGEGUIMenuItem = class(THGEGUIObject,IHGEGUIMenuItem)
  private
    { IHGEGUIMenuItem }
    procedure Render;
    procedure Enter;
    procedure Leave;
  end;

See Tutorial06 for a complete example.

Operator overloading and records with methods
=============================================

As mentioned above, one of the reasons for using Delphi 2006 is that it supports
operator overloading and records with methods. This functionality is used a lot
in some original C++ helper 'structs' like hgeVector and hgeColor. In the Delphi
version, these are record types (THGEVector, THGEColor etc) with overloaded
operators and methods.

For example, a small part of the THGEVector type looks like this:

type
  THGEVector = record
  public
    X, Y: Single;
    class operator Add(const A, B: THGEVector): THGEVector;
    function Length: Single;
  end;

With this functionality, it is easy to add two vectors together or to calculate
the length of a vector:

var
  V1, V2, V3: THGEVector;
  L: Single;
begin
  V1.X := 1;  V1.Y := 5;           // Access fields directly...
  V2 := THGEVector.Create(20,10);  // ...or use constructor
  V3 := V1 + V2;
  L := V3.Length;
end;

Unfortunately, there are some issues in Delphi 2006 that cause internal errors
(C1624) when compiling more 'complicated' constructs like:

L := (V1 + V2).Length;

This issue is fixed in Delphi 2007. But if you use Delphi 2006, the workaround
is to use temporary variables to store the intermediate results (like the V3

variable in the first example).

Some C++ classes also overload the '+=', '-=' or '*=' operators. Since Delphi
doesn't support these kinds of operators, these are converted to methods called
Increment, Decrement and Scale.

Examples
========
The original tutorials that come with the C++ version are also translated to
Delphi. You will find them in the 'Tutorials' directory. By following these
tutorials, you will get a quick grasp of how to use Haaf's Game Engine.

In addition, there is an APITester sample application that shows most of the
HGE APIs in action. It also shows the source code for each example so you can
quickly see how to use the framework.

The Font Editor and Particle System Editor have NOT been converted to Delphi.
If you want to create your own fonts or particle systems, you can use the tools
from the original version. If you download the HGE package from
http://hge.relishgames.com, you will find precompiled versions of these tools.
Of course, you can use the fonts and particle systems created with these tools
in your Delphi projects (provided that the file formats don't change).
