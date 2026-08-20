import Sound
import lean_certs.cert_34_108

open CertVerify

theorem H34_gt_108 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 34) (d := 108) (c := cert_34_108) (by native_decide)
