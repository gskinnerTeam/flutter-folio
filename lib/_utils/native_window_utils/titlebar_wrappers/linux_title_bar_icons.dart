import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _linuxMinimizeIconSvg = """
 <svg height="16" width="16" xmlns="http://www.w3.org/2000/svg">
     <path d="M4 10v1h8v-1z" style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;shape-padding:0;isolation:auto;mix-blend-mode:normal" color="#000" font-weight="400" font-family="sans-serif" white-space="normal" overflow="visible" fill="gray"/>
 </svg>
 """;

const _linuxMaximizeIconSvg = """
 <svg height="16" width="16" xmlns="http://www.w3.org/2000/svg">
     <path d="M4 4v8h8V4zm1 1h6v6H5z" style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;shape-padding:0;isolation:auto;mix-blend-mode:normal" color="#000" font-weight="400" font-family="sans-serif" white-space="normal" overflow="visible" fill="gray"/>
 </svg>
 """;

const _linuxUnmaximizeIconSvg = """
 <svg height="16" width="16" xmlns="http://www.w3.org/2000/svg">
     <g color="#000" font-weight="400" font-family="sans-serif" white-space="normal" fill="gray">
         <path d="M4 6v6h6V6zm1 1h4v4H5z" style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;shape-padding:0;isolation:auto;mix-blend-mode:normal" overflow="visible"/>
         <path d="M6 4v1h5v5h1V4z" style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;shape-padding:0;isolation:auto;mix-blend-mode:normal" overflow="visible" opacity=".5"/>
     </g>
 </svg>
 """;

const _linuxCloseIconSvg = """
 <svg height="16" width="16" xmlns="http://www.w3.org/2000/svg">
     <path d="M4.795 3.912l-.883.883.147.146L7.117 8 4.06 11.059l-.147.146.883.883.146-.147L8 8.883l3.059 3.058.146.147.883-.883-.147-.146L8.883 8l3.058-3.059.147-.146-.883-.883-.146.147L8 7.117 4.941 4.06z" style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;shape-padding:0;isolation:auto;mix-blend-mode:normal" color="#000" font-weight="400" font-family="sans-serif" white-space="normal" overflow="visible" fill="gray" fill-rule="evenodd"/>
 </svg>
 """;

class LinuxMinimizeIcon extends StatelessWidget {
  const LinuxMinimizeIcon({required this.color, Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_linuxMinimizeIconSvg, color: color);
  }
}

class LinuxMaximizeIcon extends StatelessWidget {
  const LinuxMaximizeIcon({required this.color, Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_linuxMaximizeIconSvg, color: color);
  }
}

class LinuxUnmaximizeIcon extends StatelessWidget {
  const LinuxUnmaximizeIcon({required this.color, Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_linuxUnmaximizeIconSvg, color: color);
  }
}

class LinuxCloseIcon extends StatelessWidget {
  const LinuxCloseIcon({required this.color, Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_linuxCloseIconSvg, color: color);
  }
}
