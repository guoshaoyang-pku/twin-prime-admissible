import Sound
import lean_certs.cert_40_108

open CertVerify

theorem H40_gt_108 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 40) (d := 108) (c := cert_40_108) (by native_decide)
