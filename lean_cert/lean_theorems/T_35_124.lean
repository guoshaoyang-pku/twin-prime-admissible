import Sound
import lean_certs.cert_35_124

open CertVerify

theorem H35_gt_124 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 35) (d := 124) (c := cert_35_124) (by native_decide)
