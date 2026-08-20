import Sound
import lean_certs.cert_35_108

open CertVerify

theorem H35_gt_108 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 35) (d := 108) (c := cert_35_108) (by native_decide)
