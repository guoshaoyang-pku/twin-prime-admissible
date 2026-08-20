import Sound
import lean_certs.cert_47_124

open CertVerify

theorem H47_gt_124 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 47) (d := 124) (c := cert_47_124) (by native_decide)
