
open Eliom_lib
open Eliom_content_core

module XML = XML

module SVG = struct

  module F = SVG.F
  module D = SVG.D
  module Id = SVG.Id

  type 'a elt = 'a F.elt
  type 'a attrib = 'a F.attrib
  type uri = F.uri

end

module HTML5 = struct

  module F = struct
    include HTML5.F
    include Eliom_output_base.Html5_forms.F
  end

  module D = struct
    include HTML5.D
    include Eliom_output_base.Html5_forms.D
  end

  module Id = HTML5.Id

  type 'a elt = 'a F.elt
  type 'a attrib = 'a F.attrib
  type uri = F.uri

  module Of_dom = HTML5.Of_dom

  module To_dom = struct

    open Eliom_client

    let element = rebuild_node
    let heading = rebuild_node

    let a = rebuild_node
    let abbr = rebuild_node
    let acronym = rebuild_node
    let address = rebuild_node
    let applet = rebuild_node
    let area = rebuild_node
    let article = rebuild_node
    let aside = rebuild_node
    let audio = rebuild_node
    let b = rebuild_node
    let base = rebuild_node
    let basefont = rebuild_node
    let bdi = rebuild_node
    let bdo = rebuild_node
    let big = rebuild_node
    let blockquote = rebuild_node
    let body = rebuild_node
    let br = rebuild_node
    let button = rebuild_node
    let canvas = rebuild_node
    let caption = rebuild_node
    let center = rebuild_node
    let cite = rebuild_node
    let code = rebuild_node
    let col = rebuild_node
    let colgroup = rebuild_node
    let command = rebuild_node
    let datalist = rebuild_node
    let dd = rebuild_node
    let del = rebuild_node
    let details = rebuild_node
    let dfn = rebuild_node
    let dir = rebuild_node
    let div = rebuild_node
    let dl = rebuild_node
    let dt = rebuild_node
    let em = rebuild_node
    let embed = rebuild_node
    let fieldset = rebuild_node
    let figcaption = rebuild_node
    let figure = rebuild_node
    let font = rebuild_node
    let footer = rebuild_node
    let form = rebuild_node
    let frame = rebuild_node
    let frameset = rebuild_node
    let h1 = rebuild_node
    let h2 = rebuild_node
    let h3 = rebuild_node
    let h4 = rebuild_node
    let h5 = rebuild_node
    let h6 = rebuild_node
    let head = rebuild_node
    let header = rebuild_node
    let hgroup = rebuild_node
    let hr = rebuild_node
    let html = rebuild_node
    let i = rebuild_node
    let iframe = rebuild_node
    let img = rebuild_node
    let input = rebuild_node
    let ins = rebuild_node
    let keygen = rebuild_node
    let kbd = rebuild_node
    let label = rebuild_node
    let legend = rebuild_node
    let li = rebuild_node
    let link = rebuild_node
    let map = rebuild_node
    let mark = rebuild_node
    let menu = rebuild_node
    let meta = rebuild_node
    let meter = rebuild_node
    let nav = rebuild_node
    let noframes = rebuild_node
    let noscript = rebuild_node
    let object_ = rebuild_node
    let ol = rebuild_node
    let optgroup = rebuild_node
    let option = rebuild_node
    let output = rebuild_node
    let p = rebuild_node
    let param = rebuild_node
    let pre = rebuild_node
    let progress = rebuild_node
    let q = rebuild_node
    let rp = rebuild_node
    let rt = rebuild_node
    let ruby = rebuild_node
    let s = rebuild_node
    let samp = rebuild_node
    let script = rebuild_node
    let section = rebuild_node
    let select = rebuild_node
    let small = rebuild_node
    let source = rebuild_node
    let span = rebuild_node
    let strike = rebuild_node
    let strong = rebuild_node
    let style = rebuild_node
    let sub = rebuild_node
    let summary = rebuild_node
    let sup = rebuild_node
    let table = rebuild_node
    let tbody = rebuild_node
    let td = rebuild_node
    let textarea = rebuild_node
    let tfoot = rebuild_node
    let th = rebuild_node
    let thead = rebuild_node
    let time = rebuild_node
    let title = rebuild_node
    let tr = rebuild_node
    let track = rebuild_node
    let tt = rebuild_node
    let u = rebuild_node
    let ul = rebuild_node
    let var = rebuild_node
    let video = rebuild_node
    let wbr = rebuild_node

    let pcdata = rebuild_node
  end

  module Manip = struct
    let get_node elt = (To_dom.element elt :> Dom.node Js.t)
    let get_unique_node name (elt: 'a HTML5.elt) : Dom.node Js.t =
      match XML.get_node (HTML5.D.toelt elt) with
      | XML.DomNode node -> node
      | XML.TyXMLNode desc ->
          match XML.get_node_id (HTML5.D.toelt elt) with
          | XML.NoId -> failwith (Printf.sprintf "Non unique node (%s)" name)
          | _ -> get_node elt

    let get_unique_elt name elt : Dom_html.element Js.t =
      Js.Opt.case
        (Dom_html.CoerceTo.element (get_unique_node name elt))
        (fun () -> failwith (Printf.sprintf "Non element node (%s)" name))
        id

    let raw_appendChild ?before node elt2 =
      match before with
      | None -> ignore(node##appendChild(get_node elt2))
      | Some elt3 ->
          let node3 = get_unique_node "appendChild" elt3 in
          ignore(node##insertBefore(get_node elt2, Js.some node3))


    let raw_appendChilds ?before node elts =
      match before with
      | None ->
          List.iter (fun elt2 -> ignore(node##appendChild(get_node elt2))) elts
      | Some elt3 ->
          let node3 = get_unique_node "appendChild" elt3 in
          List.iter (fun elt2 -> ignore(node##insertBefore(get_node elt2, Js.some node3))) elts

    let raw_removeChild node1 elt2 =
      let node2 = get_unique_node "removeChild" elt2 in
      ignore(node1##removeChild(node2))

    let raw_replaceChild node1 elt2 elt3 =
      let node2 = get_unique_node "replaceChild" elt2 in
      ignore(node1##replaceChild(node2, get_node elt3))

    let raw_removeAllChild node =
      let childrens = Dom.list_of_nodeList (node##childNodes) in
      List.iter (fun c -> ignore(node##removeChild(c))) childrens

    let raw_replaceAllChild node elts =
      raw_removeAllChild node;
      List.iter (fun elt -> ignore(node##appendChild(get_node elt))) elts

    let appendChild ?before elt1 elt2 =
      let node = get_unique_node "appendChild" elt1 in
      raw_appendChild ?before node elt2

    let appendChilds ?before elt1 elts =
      let node = get_unique_node "appendChilds" elt1 in
      raw_appendChilds ?before node elts

    let removeChild elt1 elt2 =
      let node1 = get_unique_node "removeChild" elt1 in
      raw_removeChild node1 elt2

    let replaceChild elt1 elt2 elt3 =
      let node1 = get_unique_node "replaceChild" elt1 in
      raw_replaceChild node1 elt2 elt3

    let removeAllChild elt =
      let node = get_unique_node "removeAllChild" elt in
      raw_removeAllChild node

    let replaceAllChild elt elts =
      let node = get_unique_node "replaceAllChild" elt in
      raw_replaceAllChild node elts

    let childNodes elt =
      let node = get_unique_node "childNodes" elt in
      Dom.list_of_nodeList (node##childNodes)

    let rec filterElements nodes = match nodes with
      | [] -> []
      | node :: nodes ->
        let elts = filterElements nodes in
        Js.Opt.case
          (Dom.CoerceTo.element node)
          (fun () -> elts)
          (fun elt -> elt :: elts)

    let childElements elt =
      let node = get_unique_node "childElements" elt in
      filterElements (Dom.list_of_nodeList (node##childNodes))

    let raw_addEventListener ?(capture = false) node event handler =
      Dom_html.addEventListener node event
        (Dom_html.full_handler (fun n e -> Js.bool (handler (HTML5.D.tot (XML.make_dom (n :> Dom.node Js.t))) e)))
        (Js.bool capture)

    let addEventListener ?capture target event handler =
      let node = get_unique_elt "addEventListener" target in
      raw_addEventListener ?capture node event handler

    module Named = struct
      let get_element id =
        let id = HTML5.Id.string_of_id id in
        let node = Eliom_client.getElementById id in
        Js.Opt.case
          (Dom_html.CoerceTo.element node)
          (fun () -> failwith (Printf.sprintf "Non element node (%s)" id))
          (fun x -> x)

      let appendChild ?before id1 elt2 =
        let node = get_element id1 in
        raw_appendChild ?before node elt2

      let appendChilds ?before id1 elts =
        let node = get_element id1 in
        raw_appendChilds ?before node elts

      let removeChild id1 elt2 =
        let node1 = get_element id1 in
        raw_removeChild node1 elt2

      let replaceChild id1 elt2 elt3 =
        let node1 = get_element id1 in
        raw_replaceChild node1 elt2 elt3

      let removeAllChild id =
        let node = get_element id in
        raw_removeAllChild node

      let replaceAllChild id elts =
        let node = get_element id in
        raw_replaceAllChild node elts

      let addEventListener ?capture id event handler =
        let node = get_element id in
        raw_addEventListener ?capture node event handler

    end

    let scrollIntoView ?(bottom = false) elt =
      let elt = get_unique_elt "Css.background" elt in
      elt##scrollIntoView(Js.bool (not bottom))

    module Css = struct
      let background elt =
        let elt = get_unique_elt "Css.background" elt in
        Js.to_bytestring (elt##style##background)
      let backgroundAttachment elt =
        let elt = get_unique_elt "Css.backgroundAttachment" elt in
        Js.to_bytestring (elt##style##backgroundAttachment)
      let backgroundColor elt =
        let elt = get_unique_elt "Css.backgroundColor" elt in
        Js.to_bytestring (elt##style##backgroundColor)
      let backgroundImage elt =
        let elt = get_unique_elt "Css.backgroundImage" elt in
        Js.to_bytestring (elt##style##backgroundImage)
      let backgroundPosition elt =
        let elt = get_unique_elt "Css.backgroundPosition" elt in
        Js.to_bytestring (elt##style##backgroundPosition)
      let backgroundRepeat elt =
        let elt = get_unique_elt "Css.backgroundRepeat" elt in
        Js.to_bytestring (elt##style##backgroundRepeat)
      let border elt =
        let elt = get_unique_elt "Css.border" elt in
        Js.to_bytestring (elt##style##border)
      let borderBottom elt =
        let elt = get_unique_elt "Css.borderBottom" elt in
        Js.to_bytestring (elt##style##borderBottom)
      let borderBottomColor elt =
        let elt = get_unique_elt "Css.borderBottomColor" elt in
        Js.to_bytestring (elt##style##borderBottomColor)
      let borderBottomStyle elt =
        let elt = get_unique_elt "Css.borderBottomStyle" elt in
        Js.to_bytestring (elt##style##borderBottomStyle)
      let borderBottomWidth elt =
        let elt = get_unique_elt "Css.borderBottomWidth" elt in
        Js.to_bytestring (elt##style##borderBottomWidth)
      let borderCollapse elt =
        let elt = get_unique_elt "Css.borderCollapse" elt in
        Js.to_bytestring (elt##style##borderCollapse)
      let borderColor elt =
        let elt = get_unique_elt "Css.borderColor" elt in
        Js.to_bytestring (elt##style##borderColor)
      let borderLeft elt =
        let elt = get_unique_elt "Css.borderLeft" elt in
        Js.to_bytestring (elt##style##borderLeft)
      let borderLeftColor elt =
        let elt = get_unique_elt "Css.borderLeftColor" elt in
        Js.to_bytestring (elt##style##borderLeftColor)
      let borderLeftStyle elt =
        let elt = get_unique_elt "Css.borderLeftStyle" elt in
        Js.to_bytestring (elt##style##borderLeftStyle)
      let borderLeftWidth elt =
        let elt = get_unique_elt "Css.borderLeftWidth" elt in
        Js.to_bytestring (elt##style##borderLeftWidth)
      let borderRight elt =
        let elt = get_unique_elt "Css.borderRight" elt in
        Js.to_bytestring (elt##style##borderRight)
      let borderRightColor elt =
        let elt = get_unique_elt "Css.borderRightColor" elt in
        Js.to_bytestring (elt##style##borderRightColor)
      let borderRightStyle elt =
        let elt = get_unique_elt "Css.borderRightStyle" elt in
        Js.to_bytestring (elt##style##borderRightStyle)
      let borderRightWidth elt =
        let elt = get_unique_elt "Css.borderRightWidth" elt in
        Js.to_bytestring (elt##style##borderRightWidth)
      let borderSpacing elt =
        let elt = get_unique_elt "Css.borderSpacing" elt in
        Js.to_bytestring (elt##style##borderSpacing)
      let borderStyle elt =
        let elt = get_unique_elt "Css.borderStyle" elt in
        Js.to_bytestring (elt##style##borderStyle)
      let borderTop elt =
        let elt = get_unique_elt "Css.borderTop" elt in
        Js.to_bytestring (elt##style##borderTop)
      let borderTopColor elt =
        let elt = get_unique_elt "Css.borderTopColor" elt in
        Js.to_bytestring (elt##style##borderTopColor)
      let borderTopStyle elt =
        let elt = get_unique_elt "Css.borderTopStyle" elt in
        Js.to_bytestring (elt##style##borderTopStyle)
      let borderTopWidth elt =
        let elt = get_unique_elt "Css.borderTopWidth" elt in
        Js.to_bytestring (elt##style##borderTopWidth)
      let borderWidth elt =
        let elt = get_unique_elt "Css.borderWidth" elt in
        Js.to_bytestring (elt##style##borderWidth)
      let bottom elt =
        let elt = get_unique_elt "Css.bottom" elt in
        Js.to_bytestring (elt##style##bottom)
      let captionSide elt =
        let elt = get_unique_elt "Css.captionSide" elt in
        Js.to_bytestring (elt##style##captionSide)
      let clear elt =
        let elt = get_unique_elt "Css.clear" elt in
        Js.to_bytestring (elt##style##clear)
      let clip elt =
        let elt = get_unique_elt "Css.clip" elt in
        Js.to_bytestring (elt##style##clip)
      let color elt =
        let elt = get_unique_elt "Css.color" elt in
        Js.to_bytestring (elt##style##color)
      let content elt =
        let elt = get_unique_elt "Css.content" elt in
        Js.to_bytestring (elt##style##content)
      let counterIncrement elt =
        let elt = get_unique_elt "Css.counterIncrement" elt in
        Js.to_bytestring (elt##style##counterIncrement)
      let counterReset elt =
        let elt = get_unique_elt "Css.counterReset" elt in
        Js.to_bytestring (elt##style##counterReset)
      let cssFloat elt =
        let elt = get_unique_elt "Css.cssFloat" elt in
        Js.to_bytestring (elt##style##cssFloat)
      let cssText elt =
        let elt = get_unique_elt "Css.cssText" elt in
        Js.to_bytestring (elt##style##cssText)
      let cursor elt =
        let elt = get_unique_elt "Css.cursor" elt in
        Js.to_bytestring (elt##style##cursor)
      let direction elt =
        let elt = get_unique_elt "Css.direction" elt in
        Js.to_bytestring (elt##style##direction)
      let display elt =
        let elt = get_unique_elt "Css.display" elt in
        Js.to_bytestring (elt##style##display)
      let emptyCells elt =
        let elt = get_unique_elt "Css.emptyCells" elt in
        Js.to_bytestring (elt##style##emptyCells)
      let font elt =
        let elt = get_unique_elt "Css.font" elt in
        Js.to_bytestring (elt##style##font)
      let fontFamily elt =
        let elt = get_unique_elt "Css.fontFamily" elt in
        Js.to_bytestring (elt##style##fontFamily)
      let fontSize elt =
        let elt = get_unique_elt "Css.fontSize" elt in
        Js.to_bytestring (elt##style##fontSize)
      let fontStyle elt =
        let elt = get_unique_elt "Css.fontStyle" elt in
        Js.to_bytestring (elt##style##fontStyle)
      let fontVariant elt =
        let elt = get_unique_elt "Css.fontVariant" elt in
        Js.to_bytestring (elt##style##fontVariant)
      let fontWeight elt =
        let elt = get_unique_elt "Css.fontWeight" elt in
        Js.to_bytestring (elt##style##fontWeight)
      let height elt =
        let elt = get_unique_elt "Css.height" elt in
        Js.to_bytestring (elt##style##height)
      let left elt =
        let elt = get_unique_elt "Css.left" elt in
        Js.to_bytestring (elt##style##left)
      let letterSpacing elt =
        let elt = get_unique_elt "Css.letterSpacing" elt in
        Js.to_bytestring (elt##style##letterSpacing)
      let lineHeight elt =
        let elt = get_unique_elt "Css.lineHeight" elt in
        Js.to_bytestring (elt##style##lineHeight)
      let listStyle elt =
        let elt = get_unique_elt "Css.listStyle" elt in
        Js.to_bytestring (elt##style##listStyle)
      let listStyleImage elt =
        let elt = get_unique_elt "Css.listStyleImage" elt in
        Js.to_bytestring (elt##style##listStyleImage)
      let listStylePosition elt =
        let elt = get_unique_elt "Css.listStylePosition" elt in
        Js.to_bytestring (elt##style##listStylePosition)
      let listStyleType elt =
        let elt = get_unique_elt "Css.listStyleType" elt in
        Js.to_bytestring (elt##style##listStyleType)
      let margin elt =
        let elt = get_unique_elt "Css.margin" elt in
        Js.to_bytestring (elt##style##margin)
      let marginBottom elt =
        let elt = get_unique_elt "Css.marginBottom" elt in
        Js.to_bytestring (elt##style##marginBottom)
      let marginLeft elt =
        let elt = get_unique_elt "Css.marginLeft" elt in
        Js.to_bytestring (elt##style##marginLeft)
      let marginRight elt =
        let elt = get_unique_elt "Css.marginRight" elt in
        Js.to_bytestring (elt##style##marginRight)
      let marginTop elt =
        let elt = get_unique_elt "Css.marginTop" elt in
        Js.to_bytestring (elt##style##marginTop)
      let maxHeight elt =
        let elt = get_unique_elt "Css.maxHeight" elt in
        Js.to_bytestring (elt##style##maxHeight)
      let maxWidth elt =
        let elt = get_unique_elt "Css.maxWidth" elt in
        Js.to_bytestring (elt##style##maxWidth)
      let minHeight elt =
        let elt = get_unique_elt "Css.minHeight" elt in
        Js.to_bytestring (elt##style##minHeight)
      let minWidth elt =
        let elt = get_unique_elt "Css.minWidth" elt in
        Js.to_bytestring (elt##style##minWidth)
      let opacity elt =
        let elt = get_unique_elt "Css.opacity" elt in
        Option.map Js.to_bytestring (Js.Optdef.to_option (elt##style##opacity))
      let outline elt =
        let elt = get_unique_elt "Css.outline" elt in
        Js.to_bytestring (elt##style##outline)
      let outlineColor elt =
        let elt = get_unique_elt "Css.outlineColor" elt in
        Js.to_bytestring (elt##style##outlineColor)
      let outlineOffset elt =
        let elt = get_unique_elt "Css.outlineOffset" elt in
        Js.to_bytestring (elt##style##outlineOffset)
      let outlineStyle elt =
        let elt = get_unique_elt "Css.outlineStyle" elt in
        Js.to_bytestring (elt##style##outlineStyle)
      let outlineWidth elt =
        let elt = get_unique_elt "Css.outlineWidth" elt in
        Js.to_bytestring (elt##style##outlineWidth)
      let overflow elt =
        let elt = get_unique_elt "Css.overflow" elt in
        Js.to_bytestring (elt##style##overflow)
      let overflowX elt =
        let elt = get_unique_elt "Css.overflowX" elt in
        Js.to_bytestring (elt##style##overflowX)
      let overflowY elt =
        let elt = get_unique_elt "Css.overflowY" elt in
        Js.to_bytestring (elt##style##overflowY)
      let padding elt =
        let elt = get_unique_elt "Css.padding" elt in
        Js.to_bytestring (elt##style##padding)
      let paddingBottom elt =
        let elt = get_unique_elt "Css.paddingBottom" elt in
        Js.to_bytestring (elt##style##paddingBottom)
      let paddingLeft elt =
        let elt = get_unique_elt "Css.paddingLeft" elt in
        Js.to_bytestring (elt##style##paddingLeft)
      let paddingRight elt =
        let elt = get_unique_elt "Css.paddingRight" elt in
        Js.to_bytestring (elt##style##paddingRight)
      let paddingTop elt =
        let elt = get_unique_elt "Css.paddingTop" elt in
        Js.to_bytestring (elt##style##paddingTop)
      let pageBreakAfter elt =
        let elt = get_unique_elt "Css.pageBreakAfter" elt in
        Js.to_bytestring (elt##style##pageBreakAfter)
      let pageBreakBefore elt =
        let elt = get_unique_elt "Css.pageBreakBefore" elt in
        Js.to_bytestring (elt##style##pageBreakBefore)
      let position elt =
        let elt = get_unique_elt "Css.position" elt in
        Js.to_bytestring (elt##style##position)
      let right elt =
        let elt = get_unique_elt "Css.right" elt in
        Js.to_bytestring (elt##style##right)
      let tableLayout elt =
        let elt = get_unique_elt "Css.tableLayout" elt in
        Js.to_bytestring (elt##style##tableLayout)
      let textAlign elt =
        let elt = get_unique_elt "Css.textAlign" elt in
        Js.to_bytestring (elt##style##textAlign)
      let textDecoration elt =
        let elt = get_unique_elt "Css.textDecoration" elt in
        Js.to_bytestring (elt##style##textDecoration)
      let textIndent elt =
        let elt = get_unique_elt "Css.textIndent" elt in
        Js.to_bytestring (elt##style##textIndent)
      let textTransform elt =
        let elt = get_unique_elt "Css.textTransform" elt in
        Js.to_bytestring (elt##style##textTransform)
      let top elt =
        let elt = get_unique_elt "Css.top" elt in
        Js.to_bytestring (elt##style##top)
      let verticalAlign elt =
        let elt = get_unique_elt "Css.verticalAlign" elt in
        Js.to_bytestring (elt##style##verticalAlign)
      let visibility elt =
        let elt = get_unique_elt "Css.visibility" elt in
        Js.to_bytestring (elt##style##visibility)
      let whiteSpace elt =
        let elt = get_unique_elt "Css.whiteSpace" elt in
        Js.to_bytestring (elt##style##whiteSpace)
      let width elt =
        let elt = get_unique_elt "Css.width" elt in
        Js.to_bytestring (elt##style##width)
      let wordSpacing elt =
        let elt = get_unique_elt "Css.wordSpacing" elt in
        Js.to_bytestring (elt##style##wordSpacing)
      let zIndex elt =
        let elt = get_unique_elt "Css.zIndex" elt in
        Js.to_bytestring (elt##style##zIndex)
    end

    module SetCss = struct
      let background elt v =
        let elt = get_unique_elt "SetCss.background" elt in
        elt##style##background <- Js.bytestring v
      let backgroundAttachment elt v =
        let elt = get_unique_elt "SetCss.backgroundAttachment" elt in
        elt##style##backgroundAttachment <- Js.bytestring v
      let backgroundColor elt v =
        let elt = get_unique_elt "SetCss.backgroundColor" elt in
        elt##style##backgroundColor <- Js.bytestring v
      let backgroundImage elt v =
        let elt = get_unique_elt "SetCss.backgroundImage" elt in
        elt##style##backgroundImage <- Js.bytestring v
      let backgroundPosition elt v =
        let elt = get_unique_elt "SetCss.backgroundPosition" elt in
        elt##style##backgroundPosition <- Js.bytestring v
      let backgroundRepeat elt v =
        let elt = get_unique_elt "SetCss.backgroundRepeat" elt in
        elt##style##backgroundRepeat <- Js.bytestring v
      let border elt v =
        let elt = get_unique_elt "SetCss.border" elt in
        elt##style##border <- Js.bytestring v
      let borderBottom elt v =
        let elt = get_unique_elt "SetCss.borderBottom" elt in
        elt##style##borderBottom <- Js.bytestring v
      let borderBottomColor elt v =
        let elt = get_unique_elt "SetCss.borderBottomColor" elt in
        elt##style##borderBottomColor <- Js.bytestring v
      let borderBottomStyle elt v =
        let elt = get_unique_elt "SetCss.borderBottomStyle" elt in
        elt##style##borderBottomStyle <- Js.bytestring v
      let borderBottomWidth elt v =
        let elt = get_unique_elt "SetCss.borderBottomWidth" elt in
        elt##style##borderBottomWidth <- Js.bytestring v
      let borderCollapse elt v =
        let elt = get_unique_elt "SetCss.borderCollapse" elt in
        elt##style##borderCollapse <- Js.bytestring v
      let borderColor elt v =
        let elt = get_unique_elt "SetCss.borderColor" elt in
        elt##style##borderColor <- Js.bytestring v
      let borderLeft elt v =
        let elt = get_unique_elt "SetCss.borderLeft" elt in
        elt##style##borderLeft <- Js.bytestring v
      let borderLeftColor elt v =
        let elt = get_unique_elt "SetCss.borderLeftColor" elt in
        elt##style##borderLeftColor <- Js.bytestring v
      let borderLeftStyle elt v =
        let elt = get_unique_elt "SetCss.borderLeftStyle" elt in
        elt##style##borderLeftStyle <- Js.bytestring v
      let borderLeftWidth elt v =
        let elt = get_unique_elt "SetCss.borderLeftWidth" elt in
        elt##style##borderLeftWidth <- Js.bytestring v
      let borderRight elt v =
        let elt = get_unique_elt "SetCss.borderRight" elt in
        elt##style##borderRight <- Js.bytestring v
      let borderRightColor elt v =
        let elt = get_unique_elt "SetCss.borderRightColor" elt in
        elt##style##borderRightColor <- Js.bytestring v
      let borderRightStyle elt v =
        let elt = get_unique_elt "SetCss.borderRightStyle" elt in
        elt##style##borderRightStyle <- Js.bytestring v
      let borderRightWidth elt v =
        let elt = get_unique_elt "SetCss.borderRightWidth" elt in
        elt##style##borderRightWidth <- Js.bytestring v
      let borderSpacing elt v =
        let elt = get_unique_elt "SetCss.borderSpacing" elt in
        elt##style##borderSpacing <- Js.bytestring v
      let borderStyle elt v =
        let elt = get_unique_elt "SetCss.borderStyle" elt in
        elt##style##borderStyle <- Js.bytestring v
      let borderTop elt v =
        let elt = get_unique_elt "SetCss.borderTop" elt in
        elt##style##borderTop <- Js.bytestring v
      let borderTopColor elt v =
        let elt = get_unique_elt "SetCss.borderTopColor" elt in
        elt##style##borderTopColor <- Js.bytestring v
      let borderTopStyle elt v =
        let elt = get_unique_elt "SetCss.borderTopStyle" elt in
        elt##style##borderTopStyle <- Js.bytestring v
      let borderTopWidth elt v =
        let elt = get_unique_elt "SetCss.borderTopWidth" elt in
        elt##style##borderTopWidth <- Js.bytestring v
      let borderWidth elt v =
        let elt = get_unique_elt "SetCss.borderWidth" elt in
        elt##style##borderWidth <- Js.bytestring v
      let bottom elt v =
        let elt = get_unique_elt "SetCss.bottom" elt in
        elt##style##bottom <- Js.bytestring v
      let captionSide elt v =
        let elt = get_unique_elt "SetCss.captionSide" elt in
        elt##style##captionSide <- Js.bytestring v
      let clear elt v =
        let elt = get_unique_elt "SetCss.clear" elt in
        elt##style##clear <- Js.bytestring v
      let clip elt v =
        let elt = get_unique_elt "SetCss.clip" elt in
        elt##style##clip <- Js.bytestring v
      let color elt v =
        let elt = get_unique_elt "SetCss.color" elt in
        elt##style##color <- Js.bytestring v
      let content elt v =
        let elt = get_unique_elt "SetCss.content" elt in
        elt##style##content <- Js.bytestring v
      let counterIncrement elt v =
        let elt = get_unique_elt "SetCss.counterIncrement" elt in
        elt##style##counterIncrement <- Js.bytestring v
      let counterReset elt v =
        let elt = get_unique_elt "SetCss.counterReset" elt in
        elt##style##counterReset <- Js.bytestring v
      let cssFloat elt v =
        let elt = get_unique_elt "SetCss.cssFloat" elt in
        elt##style##cssFloat <- Js.bytestring v
      let cssText elt v =
        let elt = get_unique_elt "SetCss.cssText" elt in
        elt##style##cssText <- Js.bytestring v
      let cursor elt v =
        let elt = get_unique_elt "SetCss.cursor" elt in
        elt##style##cursor <- Js.bytestring v
      let direction elt v =
        let elt = get_unique_elt "SetCss.direction" elt in
        elt##style##direction <- Js.bytestring v
      let display elt v =
        let elt = get_unique_elt "SetCss.display" elt in
        elt##style##display <- Js.bytestring v
      let emptyCells elt v =
        let elt = get_unique_elt "SetCss.emptyCells" elt in
        elt##style##emptyCells <- Js.bytestring v
      let font elt v =
        let elt = get_unique_elt "SetCss.font" elt in
        elt##style##font <- Js.bytestring v
      let fontFamily elt v =
        let elt = get_unique_elt "SetCss.fontFamily" elt in
        elt##style##fontFamily <- Js.bytestring v
      let fontSize elt v =
        let elt = get_unique_elt "SetCss.fontSize" elt in
        elt##style##fontSize <- Js.bytestring v
      let fontStyle elt v =
        let elt = get_unique_elt "SetCss.fontStyle" elt in
        elt##style##fontStyle <- Js.bytestring v
      let fontVariant elt v =
        let elt = get_unique_elt "SetCss.fontVariant" elt in
        elt##style##fontVariant <- Js.bytestring v
      let fontWeight elt v =
        let elt = get_unique_elt "SetCss.fontWeight" elt in
        elt##style##fontWeight <- Js.bytestring v
      let height elt v =
        let elt = get_unique_elt "SetCss.height" elt in
        elt##style##height <- Js.bytestring v
      let left elt v =
        let elt = get_unique_elt "SetCss.left" elt in
        elt##style##left <- Js.bytestring v
      let letterSpacing elt v =
        let elt = get_unique_elt "SetCss.letterSpacing" elt in
        elt##style##letterSpacing <- Js.bytestring v
      let lineHeight elt v =
        let elt = get_unique_elt "SetCss.lineHeight" elt in
        elt##style##lineHeight <- Js.bytestring v
      let listStyle elt v =
        let elt = get_unique_elt "SetCss.listStyle" elt in
        elt##style##listStyle <- Js.bytestring v
      let listStyleImage elt v =
        let elt = get_unique_elt "SetCss.listStyleImage" elt in
        elt##style##listStyleImage <- Js.bytestring v
      let listStylePosition elt v =
        let elt = get_unique_elt "SetCss.listStylePosition" elt in
        elt##style##listStylePosition <- Js.bytestring v
      let listStyleType elt v =
        let elt = get_unique_elt "SetCss.listStyleType" elt in
        elt##style##listStyleType <- Js.bytestring v
      let margin elt v =
        let elt = get_unique_elt "SetCss.margin" elt in
        elt##style##margin <- Js.bytestring v
      let marginBottom elt v =
        let elt = get_unique_elt "SetCss.marginBottom" elt in
        elt##style##marginBottom <- Js.bytestring v
      let marginLeft elt v =
        let elt = get_unique_elt "SetCss.marginLeft" elt in
        elt##style##marginLeft <- Js.bytestring v
      let marginRight elt v =
        let elt = get_unique_elt "SetCss.marginRight" elt in
        elt##style##marginRight <- Js.bytestring v
      let marginTop elt v =
        let elt = get_unique_elt "SetCss.marginTop" elt in
        elt##style##marginTop <- Js.bytestring v
      let maxHeight elt v =
        let elt = get_unique_elt "SetCss.maxHeight" elt in
        elt##style##maxHeight <- Js.bytestring v
      let maxWidth elt v =
        let elt = get_unique_elt "SetCss.maxWidth" elt in
        elt##style##maxWidth <- Js.bytestring v
      let minHeight elt v =
        let elt = get_unique_elt "SetCss.minHeight" elt in
        elt##style##minHeight <- Js.bytestring v
      let minWidth elt v =
        let elt = get_unique_elt "SetCss.minWidth" elt in
        elt##style##minWidth <- Js.bytestring v
      let opacity elt v =
        let elt = get_unique_elt "SetCss.opacity" elt in
        elt##style##opacity <- match v with None -> Js.undefined | Some v -> Js.def (Js.bytestring v)
      let outline elt v =
        let elt = get_unique_elt "SetCss.outline" elt in
        elt##style##outline <- Js.bytestring v
      let outlineColor elt v =
        let elt = get_unique_elt "SetCss.outlineColor" elt in
        elt##style##outlineColor <- Js.bytestring v
      let outlineOffset elt v =
        let elt = get_unique_elt "SetCss.outlineOffset" elt in
        elt##style##outlineOffset <- Js.bytestring v
      let outlineStyle elt v =
        let elt = get_unique_elt "SetCss.outlineStyle" elt in
        elt##style##outlineStyle <- Js.bytestring v
      let outlineWidth elt v =
        let elt = get_unique_elt "SetCss.outlineWidth" elt in
        elt##style##outlineWidth <- Js.bytestring v
      let overflow elt v =
        let elt = get_unique_elt "SetCss.overflow" elt in
        elt##style##overflow <- Js.bytestring v
      let overflowX elt v =
        let elt = get_unique_elt "SetCss.overflowX" elt in
        elt##style##overflowX <- Js.bytestring v
      let overflowY elt v =
        let elt = get_unique_elt "SetCss.overflowY" elt in
        elt##style##overflowY <- Js.bytestring v
      let padding elt v =
        let elt = get_unique_elt "SetCss.padding" elt in
        elt##style##padding <- Js.bytestring v
      let paddingBottom elt v =
        let elt = get_unique_elt "SetCss.paddingBottom" elt in
        elt##style##paddingBottom <- Js.bytestring v
      let paddingLeft elt v =
        let elt = get_unique_elt "SetCss.paddingLeft" elt in
        elt##style##paddingLeft <- Js.bytestring v
      let paddingRight elt v =
        let elt = get_unique_elt "SetCss.paddingRight" elt in
        elt##style##paddingRight <- Js.bytestring v
      let paddingTop elt v =
        let elt = get_unique_elt "SetCss.paddingTop" elt in
        elt##style##paddingTop <- Js.bytestring v
      let pageBreakAfter elt v =
        let elt = get_unique_elt "SetCss.pageBreakAfter" elt in
        elt##style##pageBreakAfter <- Js.bytestring v
      let pageBreakBefore elt v =
        let elt = get_unique_elt "SetCss.pageBreakBefore" elt in
        elt##style##pageBreakBefore <- Js.bytestring v
      let position elt v =
        let elt = get_unique_elt "SetCss.position" elt in
        elt##style##position <- Js.bytestring v
      let right elt v =
        let elt = get_unique_elt "SetCss.right" elt in
        elt##style##right <- Js.bytestring v
      let tableLayout elt v =
        let elt = get_unique_elt "SetCss.tableLayout" elt in
        elt##style##tableLayout <- Js.bytestring v
      let textAlign elt v =
        let elt = get_unique_elt "SetCss.textAlign" elt in
        elt##style##textAlign <- Js.bytestring v
      let textDecoration elt v =
        let elt = get_unique_elt "SetCss.textDecoration" elt in
        elt##style##textDecoration <- Js.bytestring v
      let textIndent elt v =
        let elt = get_unique_elt "SetCss.textIndent" elt in
        elt##style##textIndent <- Js.bytestring v
      let textTransform elt v =
        let elt = get_unique_elt "SetCss.textTransform" elt in
        elt##style##textTransform <- Js.bytestring v
      let top elt v =
        let elt = get_unique_elt "SetCss.top" elt in
        elt##style##top <- Js.bytestring v
      let verticalAlign elt v =
        let elt = get_unique_elt "SetCss.verticalAlign" elt in
        elt##style##verticalAlign <- Js.bytestring v
      let visibility elt v =
        let elt = get_unique_elt "SetCss.visibility" elt in
        elt##style##visibility <- Js.bytestring v
      let whiteSpace elt v =
        let elt = get_unique_elt "SetCss.whiteSpace" elt in
        elt##style##whiteSpace <- Js.bytestring v
      let width elt v =
        let elt = get_unique_elt "SetCss.width" elt in
        elt##style##width <- Js.bytestring v
      let wordSpacing elt v =
        let elt = get_unique_elt "SetCss.wordSpacing" elt in
        elt##style##wordSpacing <- Js.bytestring v
      let zIndex elt v =
        let elt = get_unique_elt "SetCss.zIndex" elt in
        elt##style##zIndex <- Js.bytestring v
    end
  end
end
