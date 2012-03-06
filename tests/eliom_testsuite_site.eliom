
(*****************************************************************************)
(** References of scope site *)

let reference_scope_site =
  let action =
    Eliom_output.Action.register_post_coservice'
      ~post_params:(Eliom_parameters.string "v")
      (fun () v ->
         lwt () = Eliom_references.set Eliom_testsuite_global.eref (Some v) in
         Eliom_references.set Eliom_testsuite_global.eref' (Some v))
  in
  Eliom_output.Html5.register_service
    ~path:["reference_scope_site"]
    ~get_params:Eliom_parameters.unit
    (fun () () ->
       let show = function None -> HTML5.entity "#x2012" | Some str -> HTML5.pcdata str in
       lwt v = Lwt.map show (Eliom_references.get Eliom_testsuite_global.eref) in
       lwt v' = Lwt.map show (Eliom_references.get Eliom_testsuite_global.eref') in
       Lwt.return HTML5.(
         html
           (head (title (pcdata "")) [])
           (body [
             p [
               pcdata "This is site ";
               em [pcdata (Eliom_common.((get_sp ()).sp_sitedata.config_info).Ocsigen_extensions.default_hostname)];
             ];
             p [pcdata "Open other site (substitute localhost by 127.0.0.1 in the URL or vice verse)."];
             p [
               pcdata "Current value "; i [v];
               pcdata ", persistent "; i [v'];
             ];
             pcdata "Enter a new string for both references";
             Eliom_output.Html5.post_form
               ~service:action
               (fun name ->
                  [Eliom_output.Html5.string_input ~input_type:`Text ~name ()])
               ()
           ])
       ))